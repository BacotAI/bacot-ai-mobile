import 'dart:async';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_interview_ai/domain/on_interview/entities/scoring_result.dart';
import 'package:smart_interview_ai/domain/transcription/entities/transcription_status.dart';
import 'package:smart_interview_ai/infrastructure/audio_input/whisper_service.dart';
import 'package:smart_interview_ai/core/services/interview_recorder_service.dart';
import 'package:smart_interview_ai/core/services/scoring_calculator.dart';
import 'package:smart_interview_ai/domain/pre_interview/entities/question_entity.dart';
import 'package:smart_interview_ai/infrastructure/smart_camera/services/object_detector_service.dart';
import 'package:smart_interview_ai/core/helper/log_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'on_interview_event.dart';
part 'on_interview_state.dart';

@injectable
class OnInterviewBloc extends Bloc<OnInterviewEvent, OnInterviewState> {
  final InterviewRecorderService _recorderService;
  final WhisperService _whisperService;
  Timer? _timer;
  int _elapsedSeconds = 0;
  List<QuestionEntity> _questions = [];
  final List<String> _videoPaths = [];
  int _frameCounter = 0;
  StreamSubscription<double>? _amplitudeSubscription;

  final Map<int, TranscriptionStatus> _transcriptionStatuses = {};
  final Map<int, String> _transcriptions = {};

  OnInterviewBloc(this._recorderService, this._whisperService)
    : super(OnInterviewInitial()) {
    on<OnInterviewInitialized>(_onInitialized, transformer: sequential());
    on<OnInterviewStarted>(_onStarted, transformer: sequential());
    on<OnInterviewImageStreamProcessed>(
      _onImageStreamProcessed,
      transformer: droppable(),
    );
    on<OnInterviewStopped>(_onStopped, transformer: sequential());
    on<OnInterviewAudioLevelChanged>(_onAudioLevelChanged);
    on<OnInterviewTimerTicked>(_onTimerTicked);
    on<OnInterviewNextQuestionRequested>(
      _onNextQuestionRequested,
      transformer: sequential(),
    );
    on<OnInterviewTranscriptionStarted>(_onTranscriptionStarted);
    on<OnInterviewTranscriptionCompleted>(_onTranscriptionCompleted);
    on<OnInterviewTranscriptionFailed>(_onTranscriptionFailed);
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
      await _recorderService.dispose();
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

    // Start Image Stream BEFORE Video Recording for Android compatibility
    await _recorderService.startImageStream((inputImage, cameraImage) {
      if (!isClosed) {
        add(OnInterviewImageStreamProcessed(inputImage, cameraImage));
      }
    });

    try {
      await _recorderService.startVideoRecording();
    } catch (e) {
      Log.error("Gagal memulai rekaman video: $e");
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
          transcriptionStatuses: Map.from(_transcriptionStatuses),
          transcriptions: Map.from(_transcriptions),
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

    if (!isClosed) {
      try {
        await _recorderService.stopImageStream();
      } catch (e) {
        Log.error('Error stopping image stream: $e');
      }

      final videoFile = await _recorderService.stopVideoRecording();
      if (videoFile != null) {
        _videoPaths.add(videoFile.path);

        Log.debug('Log: Current state: $state');
        Log.debug('Log: Video file path: ${videoFile.path}');

        final index = (state is OnInterviewRecording)
            ? (state as OnInterviewRecording).currentQuestionIndex
            : (_questions.length - 1);

        _startTranscription(index, videoFile.path);
      }
    }

    // Dispose recorder service immediately after recording stops
    await _recorderService.dispose();

    await Future.delayed(const Duration(seconds: 1));
    if (!isClosed) {
      emit(
        OnInterviewFinished(
          lastResult ?? const ScoringResult(),
          videoPaths: List.from(_videoPaths),
          transcriptionStatuses: Map.from(_transcriptionStatuses),
          transcriptions: Map.from(_transcriptions),
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
              transcriptionStatuses: Map.from(_transcriptionStatuses),
              transcriptions: Map.from(_transcriptions),
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
        transcriptionStatuses: Map.from(_transcriptionStatuses),
        transcriptions: Map.from(_transcriptions),
      ),
    );

    try {
      await _recorderService.stopImageStream();
      final videoFile = await _recorderService.stopVideoRecording();
      if (videoFile != null) {
        _videoPaths.add(videoFile.path);
        _startTranscription(fromIndex, videoFile.path);
      }
    } catch (e) {
      Log.error("Error stopping recording during transition: $e");
    }

    // Small delay to allow camera resources to be fully released
    await Future.delayed(const Duration(milliseconds: 500));

    _elapsedSeconds = 0;
    final nextQuestion = _questions[toIndex];
    final duration = nextQuestion.estimatedDurationSeconds;

    // Start Image Stream BEFORE Video Recording for Android compatibility
    try {
      await _recorderService.startImageStream((inputImage, cameraImage) {
        if (!isClosed) {
          add(OnInterviewImageStreamProcessed(inputImage, cameraImage));
        }
      });
    } catch (e) {
      Log.error("Gagal memulai stream gambar baru: $e");
    }

    try {
      await _recorderService.startVideoRecording();
    } catch (e) {
      Log.error("Gagal memulai rekaman video baru: $e");
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
          transcriptionStatuses: Map.from(_transcriptionStatuses),
          transcriptions: Map.from(_transcriptions),
        ),
      );

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

  void _startTranscription(int index, String videoPath) {
    if (isClosed) return;

    Log.debug('Log: Starting transcription for question $index');

    add(OnInterviewTranscriptionStarted(index));

    // Run transcription in external scope/background to not block BLoC
    unawaited(() async {
      try {
        final text = await _whisperService.transcribe(videoPath);

        Log.debug('Log: Transcription completed for question $index: $text');

        if (!isClosed) {
          add(OnInterviewTranscriptionCompleted(index, text));
        }
      } catch (e) {
        if (!isClosed) {
          add(OnInterviewTranscriptionFailed(index, e.toString()));
        }
      }
    }());
  }

  void _onTranscriptionStarted(
    OnInterviewTranscriptionStarted event,
    Emitter<OnInterviewState> emit,
  ) {
    _transcriptionStatuses[event.questionIndex] =
        TranscriptionStatus.processing;
    _updateTranscriptionState(emit);
  }

  void _onTranscriptionCompleted(
    OnInterviewTranscriptionCompleted event,
    Emitter<OnInterviewState> emit,
  ) {
    _transcriptionStatuses[event.questionIndex] = TranscriptionStatus.completed;
    _transcriptions[event.questionIndex] = event.text;
    Log.success(
      "Question ${event.questionIndex + 1} transcribed: ${event.text}",
    );
    _updateTranscriptionState(emit);
  }

  void _onTranscriptionFailed(
    OnInterviewTranscriptionFailed event,
    Emitter<OnInterviewState> emit,
  ) {
    _transcriptionStatuses[event.questionIndex] = TranscriptionStatus.failed;
    Log.error(
      "Question ${event.questionIndex + 1} transcription failed: ${event.error}",
    );
    _updateTranscriptionState(emit);
  }

  void _updateTranscriptionState(Emitter<OnInterviewState> emit) {
    if (state is OnInterviewRecording) {
      emit(
        (state as OnInterviewRecording).copyWith(
          transcriptionStatuses: Map.from(_transcriptionStatuses),
          transcriptions: Map.from(_transcriptions),
        ),
      );
    } else if (state is OnInterviewStepTransition) {
      final s = state as OnInterviewStepTransition;
      emit(
        OnInterviewStepTransition(
          fromIndex: s.fromIndex,
          toIndex: s.toIndex,
          totalQuestions: s.totalQuestions,
          audioLevel: s.audioLevel,
          transcriptionStatuses: Map.from(_transcriptionStatuses),
          transcriptions: Map.from(_transcriptions),
        ),
      );
    } else if (state is OnInterviewFinished) {
      final s = state as OnInterviewFinished;
      emit(
        OnInterviewFinished(
          s.finalResult,
          videoPaths: s.videoPaths,
          transcriptionStatuses: Map.from(_transcriptionStatuses),
          transcriptions: Map.from(_transcriptions),
        ),
      );
    }
  }
}
