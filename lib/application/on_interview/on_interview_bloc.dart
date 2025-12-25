import 'dart:async';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_interview_ai/core/services/interview_recorder_service.dart';
import 'package:smart_interview_ai/core/services/scoring_calculator.dart';
import 'package:smart_interview_ai/domain/on_interview/entities/scoring_result.dart';
import 'package:smart_interview_ai/domain/pre_interview/entities/question_entity.dart';
import 'package:smart_interview_ai/infrastructure/smart_camera/services/object_detector_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'on_interview_event.dart';
part 'on_interview_state.dart';

@injectable
class OnInterviewBloc extends Bloc<OnInterviewEvent, OnInterviewState> {
  final InterviewRecorderService _recorderService;
  Timer? _timer;
  int _elapsedSeconds = 0;
  List<QuestionEntity> _questions = [];
  final List<String> _videoPaths = [];
  int _frameCounter = 0;
  StreamSubscription<double>? _amplitudeSubscription;

  OnInterviewBloc(this._recorderService) : super(OnInterviewInitial()) {
    on<OnInterviewInitialized>(_onInitialized);
    on<OnInterviewStarted>(_onStarted);
    on<OnInterviewImageStreamProcessed>(_onImageStreamProcessed);
    on<OnInterviewStopped>(_onStopped);
    on<OnInterviewAudioLevelChanged>(_onAudioLevelChanged);
    on<OnInterviewTimerTicked>(_onTimerTicked);
    on<OnInterviewNextQuestionRequested>(_onNextQuestionRequested);
  }

  FutureOr<void> _onInitialized(
    OnInterviewInitialized event,
    Emitter<OnInterviewState> emit,
  ) async {
    _questions = event.questions;
    emit(OnInterviewLoading());
    try {
      await _recorderService.initialize();
      if (!isClosed) add(const OnInterviewStarted());
    } catch (e) {
      emit(OnInterviewError("Gagal menginisialisasi kamera: $e"));
    }
  }

  FutureOr<void> _onStarted(
    OnInterviewStarted event,
    Emitter<OnInterviewState> emit,
  ) async {
    int count = 3;
    emit(OnInterviewCountdown(count));

    final countdownCompleter = Completer<void>();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      count--;
      if (count <= 0) {
        timer.cancel();
        countdownCompleter.complete();
      } else {
        if (!isClosed) {
          add(OnInterviewTimerTicked(count, isInitialCountdown: true));
        }
      }
    });

    await countdownCompleter.future;

    try {
      await _recorderService.startVideoRecording();
    } catch (e) {
      debugPrint("Gagal memulai rekaman video: $e");
    }

    _elapsedSeconds = 0;
    final duration = _questions.isNotEmpty
        ? _questions[0].estimatedDurationSeconds
        : 60;

    if (!isClosed) {
      emit(
        OnInterviewRecording(
          currentQuestionIndex: 0,
          totalQuestions: _questions.length,
          remainingSeconds: duration,
          totalDuration: duration,
          canGoNext: false,
          lastScoringResult: const ScoringResult(),
        ),
      );

      _amplitudeSubscription = _recorderService.amplitudeStream.listen((level) {
        if (!isClosed) {
          add(OnInterviewAudioLevelChanged(level));
        }
      });
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      if (!isClosed) {
        add(OnInterviewTimerTicked(_elapsedSeconds));
      }
    });

    _recorderService.startImageStream((inputImage, cameraImage) {
      if (!isClosed) {
        add(OnInterviewImageStreamProcessed(inputImage, cameraImage));
      }
    });
  }

  FutureOr<void> _onImageStreamProcessed(
    OnInterviewImageStreamProcessed event,
    Emitter<OnInterviewState> emit,
  ) async {
    if (state is! OnInterviewRecording) return;

    _frameCounter++;

    Face? face;
    List<Pose>? poses;
    ProhibitedItemResult? objectResult;

    try {
      if (_frameCounter % 3 == 0) {
        final faces = await _recorderService.processFace(event.inputImage);
        if (faces.isNotEmpty) face = faces.first;
      } else if (_frameCounter % 3 == 1) {
        final poseList = await _recorderService.processPose(event.inputImage);
        if (poseList.isNotEmpty) poses = poseList;
      } else {
        objectResult = await _recorderService.processObject(event.inputImage);
      }

      if (face != null || poses != null || objectResult != null) {
        final result = ScoringCalculator.calculate(
          face: face,
          poses: poses,
          objectResult: objectResult,
          imageSize: Size(
            event.cameraImage.width.toDouble(),
            event.cameraImage.height.toDouble(),
          ),
          screenSize: null,
        );

        if (!isClosed && state is OnInterviewRecording) {
          // emit(
          //   OnInterviewRecording(
          //     elapsedSeconds: _elapsedSeconds,
          //     totalDuration: _totalDuration,
          //     lastScoringResult: result,
          //   ),
          // );
        }
      }
    } catch (e) {
      debugPrint("ML Processing Error: $e");
    }
  }

  FutureOr<void> _onStopped(
    OnInterviewStopped event,
    Emitter<OnInterviewState> emit,
  ) async {
    _timer?.cancel();
    await _amplitudeSubscription?.cancel();
    _amplitudeSubscription = null;

    final lastResult = state is OnInterviewRecording
        ? (state as OnInterviewRecording).lastScoringResult
        : null;

    emit(OnInterviewProcessing());

    try {
      await _recorderService.stopImageStream();
      final videoFile = await _recorderService.stopVideoRecording();
      if (videoFile != null) {
        _videoPaths.add(videoFile.path);
      }
    } catch (e) {
      debugPrint("Error stopping recording: $e");
    }

    await Future.delayed(const Duration(seconds: 1));
    if (!isClosed) {
      emit(
        OnInterviewFinished(
          lastResult ?? const ScoringResult(),
          videoPaths: List.from(_videoPaths),
        ),
      );
    }
  }

  void _onAudioLevelChanged(
    OnInterviewAudioLevelChanged event,
    Emitter<OnInterviewState> emit,
  ) {
    if (state is OnInterviewRecording && !isClosed) {
      emit((state as OnInterviewRecording).copyWith(audioLevel: event.level));
    }
  }

  void _onTimerTicked(
    OnInterviewTimerTicked event,
    Emitter<OnInterviewState> emit,
  ) {
    if (isClosed) return;

    if (event.isInitialCountdown) {
      emit(OnInterviewCountdown(event.value));
    } else {
      if (state is OnInterviewRecording) {
        final currentState = state as OnInterviewRecording;
        final remaining = currentState.totalDuration - event.value;

        if (remaining <= 0) {
          _timer?.cancel();
          final nextIndex = currentState.currentQuestionIndex + 1;
          if (nextIndex < currentState.totalQuestions) {
            add(const OnInterviewNextQuestionRequested());
          } else {
            add(const OnInterviewStopped());
          }
        } else {
          emit(
            currentState.copyWith(
              remainingSeconds: math.max(0, remaining),
              canGoNext: true,
            ),
          );
        }
      }
    }
  }

  FutureOr<void> _onNextQuestionRequested(
    OnInterviewNextQuestionRequested event,
    Emitter<OnInterviewState> emit,
  ) async {
    if (state is! OnInterviewRecording) return;

    final currentState = state as OnInterviewRecording;
    final fromIndex = currentState.currentQuestionIndex;
    final toIndex = fromIndex + 1;

    emit(
      OnInterviewStepTransition(
        fromIndex: fromIndex,
        toIndex: toIndex,
        totalQuestions: _questions.length,
        audioLevel: currentState.audioLevel,
      ),
    );

    try {
      await _recorderService.stopImageStream();
      final videoFile = await _recorderService.stopVideoRecording();
      if (videoFile != null) {
        _videoPaths.add(videoFile.path);
      }
    } catch (e) {
      debugPrint("Error stopping recording during transition: $e");
    }

    _elapsedSeconds = 0;
    final nextQuestion = _questions[toIndex];
    final duration = nextQuestion.estimatedDurationSeconds;

    try {
      await _recorderService.startVideoRecording();
    } catch (e) {
      debugPrint("Gagal memulai rekaman video baru: $e");
    }

    if (!isClosed) {
      emit(
        OnInterviewRecording(
          currentQuestionIndex: toIndex,
          totalQuestions: _questions.length,
          remainingSeconds: duration,
          totalDuration: duration,
          canGoNext: false,
          lastScoringResult: currentState.lastScoringResult,
          audioLevel: currentState.audioLevel,
        ),
      );

      _recorderService.startImageStream((inputImage, cameraImage) {
        if (!isClosed) {
          add(OnInterviewImageStreamProcessed(inputImage, cameraImage));
        }
      });

      // Restart timer for next question
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _elapsedSeconds++;
        if (!isClosed) {
          add(OnInterviewTimerTicked(_elapsedSeconds));
        }
      });
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _recorderService.dispose();
    return super.close();
  }
}
