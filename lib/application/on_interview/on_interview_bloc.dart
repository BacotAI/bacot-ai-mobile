import 'dart:async';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_interview_ai/core/services/interview_recorder_service.dart';
import 'package:smart_interview_ai/core/services/scoring_calculator.dart';
import 'package:smart_interview_ai/domain/on_interview/entities/scoring_result.dart';
import 'package:smart_interview_ai/infrastructure/smart_camera/services/object_detector_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'on_interview_event.dart';
part 'on_interview_state.dart';

@injectable
class OnInterviewBloc extends Bloc<OnInterviewEvent, OnInterviewState> {
  final InterviewRecorderService _recorderService;
  Timer? _timer;
  int _elapsedSeconds = 0;
  final int _totalDuration = 60;
  int _frameCounter = 0;

  OnInterviewBloc(this._recorderService) : super(OnInterviewInitial()) {
    on<OnInterviewInitialized>(_onInitialized);
    on<OnInterviewStarted>(_onStarted);
    on<OnInterviewImageStreamProcessed>(_onImageStreamProcessed);
    on<OnInterviewStopped>(_onStopped);
  }

  FutureOr<void> _onInitialized(
    OnInterviewInitialized event,
    Emitter<OnInterviewState> emit,
  ) async {
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
        if (!isClosed) emit(OnInterviewCountdown(count));
      }
    });

    await countdownCompleter.future;

    _elapsedSeconds = 0;
    if (!isClosed) {
      // emit(
      //   OnInterviewRecording(elapsedSeconds: 0, totalDuration: _totalDuration),
      // );
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      if (_elapsedSeconds >= _totalDuration) {
        add(const OnInterviewStopped());
      } else {
        final lastResult = state is OnInterviewRecording
            ? (state as OnInterviewRecording).lastScoringResult
            : null;
        if (!isClosed) {
          // emit(
          //   OnInterviewRecording(
          //     elapsedSeconds: _elapsedSeconds,
          //     totalDuration: _totalDuration,
          //     lastScoringResult: lastResult,
          //   ),
          // );
        }
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
    final lastResult = state is OnInterviewRecording
        ? (state as OnInterviewRecording).lastScoringResult
        : null;

    emit(OnInterviewProcessing());

    await Future.delayed(const Duration(seconds: 1));
    if (!isClosed) {
      emit(OnInterviewFinished(lastResult ?? const ScoringResult()));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _recorderService.dispose();
    return super.close();
  }
}
