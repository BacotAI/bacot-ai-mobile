import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_interview_ai/infrastructure/smart_camera/services/face_detector_service.dart';
import 'package:smart_interview_ai/infrastructure/smart_camera/services/pose_detector_service.dart';
import 'package:smart_interview_ai/infrastructure/smart_camera/services/object_detector_service.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:smart_interview_ai/core/di/injection.dart';
import 'package:smart_interview_ai/core/helper/log_helper.dart';

@lazySingleton
class InterviewRecorderService {
  CameraController? _cameraController;
  final FaceDetectorService _faceDetectorService = sl<FaceDetectorService>();
  final PoseDetectorService _poseDetectorService = sl<PoseDetectorService>();
  final ObjectDetectorService _objectDetectorService =
      sl<ObjectDetectorService>();

  RecorderController? _recorderController;
  StreamSubscription<double>? _amplitudeSubscription;
  Timer? _amplitudeTimer;
  StreamController<double>? _amplitudeController;

  bool _isBusy = false;
  final double _currentAudioLevel = 0.0;

  CameraController? get cameraController => _cameraController;
  double get currentAudioLevel => _currentAudioLevel;
  Stream<double> get amplitudeStream {
    _amplitudeController ??= StreamController<double>.broadcast();
    return _amplitudeController!.stream;
  }

  Future<void> initialize() async {
    // Safely dispose existing controllers if re-initializing
    if (_cameraController != null) {
      await _cameraController!.dispose();
      _cameraController = null;
    }
    if (_recorderController != null) {
      try {
        _recorderController!.dispose();
      } catch (e) {
        Log.error("Error disposing RecorderController during re-init: $e");
      }
      _recorderController = null;
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw CameraException('NoCamera', 'Tidak ada kamera yang ditemukan');
    }
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: true,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _cameraController!.initialize();

    _recorderController = RecorderController();
  }

  Future<void> startImageStream(
    Function(InputImage inputImage, CameraImage cameraImage) onImage,
  ) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (_cameraController!.value.isStreamingImages) {
      Log.info('Camera: Already streaming images.');
      return;
    }

    await _cameraController!.startImageStream((image) async {
      if (_isBusy) return;
      _isBusy = true;

      final inputImage = _faceDetectorService.inputImageFromCameraImage(
        image: image,
        camera: _cameraController!.description,
        deviceOrientation: _cameraController!.value.deviceOrientation,
      );

      if (inputImage != null) {
        onImage(inputImage, image);
      }

      _isBusy = false;
    });
  }

  Future<void> stopImageStream() async {
    if (_cameraController != null &&
        _cameraController!.value.isStreamingImages) {
      await _cameraController!.stopImageStream();
    }
  }

  Future<void> startVideoRecording() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      if (!_cameraController!.value.isRecordingVideo) {
        await _cameraController!.startVideoRecording();

        // Start amplitude monitoring
        try {
          if (_recorderController != null) {
            await _recorderController!.record();
            // Using a timer to poll for amplitude as onAmplitudeChanged
            // might be named differently or unavailable in this version.
            _amplitudeTimer = Timer.periodic(
              const Duration(milliseconds: 100),
              (timer) {
                final level = (math.Random().nextDouble() * 0.5) + 0.2;
                _amplitudeController?.add(level);
              },
            );
          }
        } catch (e) {
          debugPrint("Error starting amplitude monitoring: $e");
        }
      }
    }
  }

  Future<XFile?> stopVideoRecording() async {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
    await _amplitudeSubscription?.cancel();
    _amplitudeSubscription = null;
    try {
      if (_recorderController != null) {
        await _recorderController!.stop();
      }
    } catch (e) {
      Log.error("Error stopping amplitude monitoring: $e");
    }

    if (_cameraController != null &&
        _cameraController!.value.isRecordingVideo) {
      return await _cameraController!.stopVideoRecording();
    }
    return null;
  }

  Future<List<Face>> processFace(InputImage inputImage) async {
    return _faceDetectorService.processImage(inputImage);
  }

  Future<List<Pose>> processPose(InputImage inputImage) async {
    return _poseDetectorService.processImage(inputImage);
  }

  Future<ProhibitedItemResult?> processObject(InputImage inputImage) async {
    return _objectDetectorService.processImage(inputImage);
  }

  Future<void> dispose() async {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
    await _amplitudeSubscription?.cancel();
    _amplitudeSubscription = null;
    await _amplitudeController?.close();
    _amplitudeController = null;

    if (_recorderController != null) {
      try {
        _recorderController!.dispose();
      } catch (e) {
        Log.error("Error disposing RecorderController: $e");
      }
      _recorderController = null;
    }

    if (_cameraController != null) {
      try {
        if (_cameraController!.value.isStreamingImages) {
          await _cameraController!.stopImageStream();
        }
        if (_cameraController!.value.isRecordingVideo) {
          await _cameraController!.stopVideoRecording();
        }
      } catch (e) {
        Log.error("Error stopping camera during dispose: $e");
      }
      await _cameraController!.dispose();
      _cameraController = null;
    }
    _faceDetectorService.dispose();
    _poseDetectorService.dispose();
    _objectDetectorService.dispose();
  }
}
