import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:smart_interview_ai/core/helper/log_helper.dart';
import 'package:smart_interview_ai/core/services/interview_recorder_service.dart';
import 'package:smart_interview_ai/core/services/scoring_calculator.dart';
import 'package:smart_interview_ai/features/on_interview/domain/entities/scoring_result.dart';
import 'package:smart_interview_ai/features/smart_camera/services/object_detector_service.dart';
import 'package:smart_interview_ai/features/pre_interview/domain/entities/question_entity.dart';
import 'package:smart_interview_ai/features/audio_input/services/whisper_service.dart';
import 'on_interview_state.dart';

class OnInterviewCubit extends Cubit<OnInterviewState> {
  final InterviewRecorderService _recorderService;
  final WhisperService _whisperService;
  final List<QuestionEntity> questions;

  Timer? _timer;
  int _currentQuestionIndex = 0;
  int _elapsedSeconds = 0;

  // Optimization: Process frames in a round-robin fashion
  int _frameCounter = 0;

  OnInterviewCubit({
    required InterviewRecorderService recorderService,
    required WhisperService whisperService,
    required this.questions,
  }) : _recorderService = recorderService,
       _whisperService = whisperService,
       super(OnInterviewInitial());

  Future<void> initialize() async {
    emit(OnInterviewLoading());
    try {
      await _recorderService.initialize();
      // await _whisperService.init();
      _startCountdown();
    } catch (e) {
      emit(OnInterviewError("Gagal menginisialisasi interview: $e"));
    }
  }

  void _startCountdown() {
    int count = 3;
    emit(OnInterviewCountdown(count));
    Timer.periodic(const Duration(seconds: 1), (timer) {
      count--;
      if (count <= 0) {
        timer.cancel();
        _startRecording();
      } else {
        emit(OnInterviewCountdown(count));
      }
    });
  }

  Future<void> _startRecording() async {
    _elapsedSeconds = 0;
    final currentQuestion = questions[_currentQuestionIndex];
    final totalDuration = currentQuestion.estimatedDurationSeconds;

    emit(
      OnInterviewRecording(
        currentQuestionIndex: _currentQuestionIndex,
        totalQuestions: questions.length,
        elapsedSeconds: 0,
        totalDuration: totalDuration,
        canGoNext: false,
      ),
    );

    try {
      await _recorderService.startVideoRecording();
    } catch (e) {
      debugPrint("Error starting video recording: $e");
    }

    // Start Timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;

      final currentState = state;
      if (currentState is OnInterviewRecording) {
        final canGoNext = _elapsedSeconds >= (totalDuration * 0.5);

        if (_elapsedSeconds >= totalDuration) {
          nextQuestion();
        } else {
          emit(
            currentState.copyWith(
              elapsedSeconds: _elapsedSeconds,
              canGoNext: canGoNext,
              audioLevel: _recorderService.currentAudioLevel,
            ),
          );
        }
      }
    });

    // Start ML Processing
    _recorderService.startImageStream((inputImage, cameraImage) async {
      if (state is! OnInterviewRecording) return;

      _frameCounter++;

      Face? face;
      List<Pose>? poses;
      ProhibitedItemResult? objectResult;

      try {
        if (_frameCounter % 3 == 0) {
          final faces = await _recorderService.processFace(inputImage);
          if (faces.isNotEmpty) face = faces.first;
        } else if (_frameCounter % 3 == 1) {
          final poseList = await _recorderService.processPose(inputImage);
          if (poseList.isNotEmpty) poses = poseList;
        } else {
          objectResult = await _recorderService.processObject(inputImage);
        }

        if (face != null || poses != null || objectResult != null) {
          final result = ScoringCalculator.calculate(
            face: face,
            poses: poses,
            objectResult: objectResult,
            imageSize: Size(
              cameraImage.width.toDouble(),
              cameraImage.height.toDouble(),
            ),
            screenSize: null,
          );

          if (!isClosed && state is OnInterviewRecording) {
            emit(
              (state as OnInterviewRecording).copyWith(
                lastScoringResult: result,
              ),
            );
          }
        }
      } catch (e) {
        debugPrint("ML Processing Error: $e");
      }
    });
  }

  Future<void> nextQuestion() async {
    _timer?.cancel();

    final videoFile = await _recorderService.stopVideoRecording();

    Log.debug("Saved video file: $videoFile");

    // if (videoFile != null) {
    //   // Trigger transcription asynchronously (don't block the UI transition)
    //   _whisperService
    //       .transcribe(videoFile.path)
    //       .then((text) {
    //         debugPrint(
    //           "Transcription for Q${_currentQuestionIndex + 1}: $text",
    //         );
    //         // TODO: Save transcription result
    //       })
    //       .catchError((e) {
    //         debugPrint(
    //           "Transcription error for Q${_currentQuestionIndex + 1}: $e",
    //         );
    //       });
    // }

    if (_currentQuestionIndex < questions.length - 1) {
      final fromIndex = _currentQuestionIndex;
      _currentQuestionIndex++;

      emit(
        OnInterviewStepTransition(
          fromIndex: fromIndex,
          toIndex: _currentQuestionIndex,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      _startRecording();
    } else {
      finishInterview();
    }
  }

  void finishInterview() {
    _timer?.cancel();
    final lastResult = state is OnInterviewRecording
        ? (state as OnInterviewRecording).lastScoringResult
        : null;

    emit(OnInterviewProcessing());

    // Final processing simulation
    Future.delayed(const Duration(seconds: 1), () {
      emit(OnInterviewFinished(lastResult ?? const ScoringResult()));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _recorderService.dispose();
    return super.close();
  }
}
