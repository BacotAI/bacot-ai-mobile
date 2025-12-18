import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:smart_interview_ai/features/on_interview/logic/interview_recorder_service.dart';
import 'package:smart_interview_ai/features/on_interview/logic/scoring_calculator.dart';
import 'package:smart_interview_ai/features/on_interview/domain/entities/scoring_result.dart';
import 'package:smart_interview_ai/features/smart_camera/services/object_detector_service.dart';
import 'on_interview_state.dart';

class OnInterviewCubit extends Cubit<OnInterviewState> {
  final InterviewRecorderService _recorderService;
  Timer? _timer;
  int _elapsedSeconds = 0;
  final int _totalDuration = 60; // Default 60 seconds

  // Optimization: Process frames in a round-robin fashion
  int _frameCounter = 0;

  OnInterviewCubit({required InterviewRecorderService recorderService})
    : _recorderService = recorderService,
      super(OnInterviewInitial());

  Future<void> initialize() async {
    emit(OnInterviewLoading());
    try {
      await _recorderService.initialize();
      startCountdown();
    } catch (e) {
      emit(OnInterviewError("Gagal menginisialisasi kamera: $e"));
    }
  }

  void startCountdown() {
    int count = 3;
    emit(OnInterviewCountdown(count));
    Timer.periodic(const Duration(seconds: 1), (timer) {
      count--;
      if (count <= 0) {
        timer.cancel();
        startRecording();
      } else {
        emit(OnInterviewCountdown(count));
      }
    });
  }

  void startRecording() {
    _elapsedSeconds = 0;
    emit(
      OnInterviewRecording(elapsedSeconds: 0, totalDuration: _totalDuration),
    );

    // Start Timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      if (_elapsedSeconds >= _totalDuration) {
        stopRecording();
      } else {
        // Keep the last state's scoring result to avoid flickering
        final lastResult = state is OnInterviewRecording
            ? (state as OnInterviewRecording).lastScoringResult
            : null;
        emit(
          OnInterviewRecording(
            elapsedSeconds: _elapsedSeconds,
            totalDuration: _totalDuration,
            lastScoringResult: lastResult,
          ),
        );
      }
    });

    // Start ML Processing
    _recorderService.startImageStream((inputImage, cameraImage) async {
      if (state is! OnInterviewRecording) return;

      _frameCounter++;

      Face? face;
      List<Pose>? poses;
      ProhibitedItemResult? objectResult;

      // Round-robin processing to save CPU
      // Frame 0, 3, 6...: Face
      // Frame 1, 4, 7...: Pose
      // Frame 2, 5, 8...: Object

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

        // Only calculate if we have something new, or use cached/partial data
        // NOTE: In a real app we'd cache the last known face/pose/object and combine them.
        // For simplicity here, we calculate partial scores or just update what we have.
        // A better approach for the overlay is to maintain a 'SessionState' object.

        if (face != null || poses != null || objectResult != null) {
          final result = ScoringCalculator.calculate(
            face: face,
            poses: poses,
            objectResult: objectResult,
            // Convert camera image size
            imageSize: Size(
              cameraImage.width.toDouble(),
              cameraImage.height.toDouble(),
            ),
            // Screen size is hard to get here without context, passing null for now
            // In a real implementation, we'd pass this in initialize or update it.
            screenSize: null,
          );

          if (!isClosed) {
            emit(
              OnInterviewRecording(
                elapsedSeconds: _elapsedSeconds,
                totalDuration: _totalDuration,
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

  void stopRecording() {
    _timer?.cancel();
    // In a real app, we would process everything here.
    // For now, we just transition to finished.
    // If we have a last result, use it.
    final lastResult = state is OnInterviewRecording
        ? (state as OnInterviewRecording).lastScoringResult
        : null;

    emit(OnInterviewProcessing());

    // Simulate processing delay
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
