import 'dart:async';
import 'dart:io';
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
import 'package:audio_waveforms/audio_waveforms.dart';

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
    on<OnInterviewSessionCleared>(_onSessionCleared);
    on<OnInterviewCameraReinitializeRequested>(_onCameraReinitializeRequested);
  }

  FutureOr<void> _onInitialized(
    OnInterviewInitialized event,
    Emitter<OnInterviewState> emit,
  ) async {
    _questions = event.questions;
    emit(OnInterviewLoading());
    try {
      await _recorderService.initialize();
      // Initialize transcription statuses for all questions
      for (int i = 0; i < _questions.length; i++) {
        _transcriptionStatuses[i] = TranscriptionStatus.idle;
      }
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
    emit(
      OnInterviewCountdown(
        count,
        recorderController: _recorderService.recorderController,
      ),
    );

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
      _handleCameraError("Gagal memulai rekaman video: $e", emit);
      return;
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
          recorderController: _recorderService.recorderController,
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

    // Clear any existing timer
    _timer?.cancel();
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

    emit(
      OnInterviewProcessing(
        transcriptionStatuses: Map.from(_transcriptionStatuses),
        transcriptions: Map.from(_transcriptions),
        finalResult: lastResult,
      ),
    );

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
        Log.debug('Log: Last video file path: ${videoFile.path}');
      }

      // Trigger parallel transcription for all recorded videos
      _startAllTranscriptions();
    }

    // Dispose recorder service immediately after recording stops
    await _recorderService.dispose();
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
      emit(
        OnInterviewCountdown(
          event.value,
          recorderController: _recorderService.recorderController,
        ),
      );
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

    // Immediately cancel current timer to prevent double ticking
    _timer?.cancel();
    _timer = null;

    emit(
      OnInterviewStepTransition(
        fromIndex: fromIndex,
        toIndex: toIndex,
        totalQuestions: _questions.length,
        audioLevel: currentState.audioLevel,
        recorderController: _recorderService.recorderController,
        transcriptionStatuses: Map.from(_transcriptionStatuses),
        transcriptions: Map.from(_transcriptions),
      ),
    );

    try {
      await _recorderService.stopImageStream();
      final videoFile = await _recorderService.stopVideoRecording();
      if (videoFile != null) {
        _videoPaths.add(videoFile.path);
      }
    } catch (e) {
      Log.error("Error stopping recording during transition: $e");
    }

    // // Small delay to allow camera resources to be fully released
    // await Future.delayed(const Duration(milliseconds: 500));

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
      _handleCameraError("Gagal memulai stream gambar baru: $e", emit);
      return;
    }

    try {
      await _recorderService.startVideoRecording();
    } catch (e) {
      Log.error("Gagal memulai rekaman video baru: $e");
      _handleCameraError("Gagal memulai rekaman video baru: $e", emit);
      return;
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
          recorderController: _recorderService.recorderController,
          transcriptionStatuses: Map.from(_transcriptionStatuses),
          transcriptions: Map.from(_transcriptions),
        ),
      );

      // Restart timer for next question
      _timer?.cancel();
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

  void _startAllTranscriptions() {
    if (isClosed) return;

    Log.info(
      'Starting parallel transcription for ${_videoPaths.length} videos',
    );

    for (int i = 0; i < _videoPaths.length; i++) {
      _startTranscription(i, _videoPaths[i]);
    }
  }

  void _startTranscription(int index, String videoPath) {
    if (isClosed) return;

    Log.debug('Log: Starting transcription for question $index');

    add(OnInterviewTranscriptionStarted(index));

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
          recorderController: _recorderService.recorderController,
          transcriptionStatuses: Map.from(_transcriptionStatuses),
          transcriptions: Map.from(_transcriptions),
        ),
      );
    } else if (state is OnInterviewProcessing) {
      final s = state as OnInterviewProcessing;
      emit(
        s.copyWith(
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

    // Check if we should transition from Processing to Finished
    if (state is OnInterviewProcessing) {
      final allDone = _transcriptionStatuses.values.every(
        (status) =>
            status == TranscriptionStatus.completed ||
            status == TranscriptionStatus.failed,
      );

      final hasAllQuestions =
          _transcriptionStatuses.length == _questions.length;

      if (allDone && hasAllQuestions && !isClosed) {
        final lastResult = (state as OnInterviewProcessing).finalResult;
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
  }

  FutureOr<void> _onSessionCleared(
    OnInterviewSessionCleared event,
    Emitter<OnInterviewState> emit,
  ) async {
    Log.info('Cleaning up interview session files...');
    for (final videoPath in _videoPaths) {
      try {
        final videoFile = File(videoPath);
        if (await videoFile.exists()) {
          await videoFile.delete();
          Log.debug('Deleted video: $videoPath');
        }

        // Also delete the transcription .wav file if it exists
        final String wavPath;
        if (videoPath.contains('.')) {
          wavPath = '${videoPath.substring(0, videoPath.lastIndexOf('.'))}.wav';
        } else {
          wavPath = '$videoPath.wav';
        }

        final wavFile = File(wavPath);
        if (await wavFile.exists()) {
          await wavFile.delete();
          Log.debug('Deleted transcription wav: $wavPath');
        }
      } catch (e) {
        Log.error('Error deleting file: $e');
      }
    }
    _videoPaths.clear();
    Log.success('Interview session cleanup completed.');
  }

  FutureOr<void> _onCameraReinitializeRequested(
    OnInterviewCameraReinitializeRequested event,
    Emitter<OnInterviewState> emit,
  ) async {
    if (state is! OnInterviewCameraFailure) return;
    final failureState = state as OnInterviewCameraFailure;

    emit(failureState.copyWith(isReinitializing: true));

    try {
      // Re-initialize the entire recorder service
      await _recorderService.initialize();

      // Depend on the previous state to decide what to resume
      final previousState = failureState.previousState;

      if (previousState is OnInterviewRecording) {
        // Resume image stream and video recording
        await _recorderService.startImageStream((inputImage, cameraImage) {
          if (!isClosed) {
            add(OnInterviewImageStreamProcessed(inputImage, cameraImage));
          }
        });
        await _recorderService.startVideoRecording();

        // Resume amplitude monitoring if it was active
        _amplitudeSubscription?.cancel();
        _amplitudeSubscription = _recorderService.amplitudeStream.listen((
          level,
        ) {
          if (!isClosed) {
            add(OnInterviewAudioLevelChanged(level));
          }
        });

        // Restart timer for recording
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (!isClosed) {
            final currentState = state;
            if (currentState is OnInterviewRecording) {
              _elapsedSeconds++;
              add(OnInterviewTimerTicked(_elapsedSeconds));
            } else {
              timer.cancel();
            }
          }
        });

        emit(previousState);
      } else if (previousState is OnInterviewStepTransition) {
        // If it failed during transition, move to the target question and start recording
        final toIndex = previousState.toIndex;
        final nextQuestion = _questions[toIndex];
        final duration = nextQuestion.estimatedDurationSeconds;

        await _recorderService.startImageStream((inputImage, cameraImage) {
          if (!isClosed) {
            add(OnInterviewImageStreamProcessed(inputImage, cameraImage));
          }
        });
        await _recorderService.startVideoRecording();

        _elapsedSeconds = 0;
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (!isClosed) {
            final currentState = state;
            if (currentState is OnInterviewRecording) {
              _elapsedSeconds++;
              add(OnInterviewTimerTicked(_elapsedSeconds));
            } else {
              timer.cancel();
            }
          }
        });

        emit(
          OnInterviewRecording(
            currentQuestionIndex: toIndex,
            totalQuestions: _questions.length,
            remainingSeconds: duration,
            totalDuration: duration,
            canGoNext: false,
            audioLevel: previousState.audioLevel,
            recorderController: _recorderService.recorderController,
            transcriptionStatuses: Map.from(_transcriptionStatuses),
            transcriptions: Map.from(_transcriptions),
          ),
        );
      } else if (previousState is OnInterviewLoading ||
          previousState is OnInterviewInitial) {
        // If it failed at the start, just trigger the normal flow
        add(const OnInterviewStarted());
      } else {
        // For other states, just go back to them
        emit(previousState);
      }
    } catch (e) {
      Log.error("Re-initialization failed: $e");
      emit(
        failureState.copyWith(
          message: "Gagal memulihkan kamera: $e",
          isReinitializing: false,
        ),
      );
    }
  }

  void _handleCameraError(String message, Emitter<OnInterviewState> emit) {
    if (state is OnInterviewCameraFailure) return;
    emit(OnInterviewCameraFailure(message: message, previousState: state));
  }
}
