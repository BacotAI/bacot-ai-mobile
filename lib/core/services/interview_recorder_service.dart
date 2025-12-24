import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_interview_ai/infrastructure/smart_camera/services/face_detector_service.dart';
import 'package:smart_interview_ai/infrastructure/smart_camera/services/pose_detector_service.dart';
import 'package:smart_interview_ai/infrastructure/smart_camera/services/object_detector_service.dart';
import 'package:smart_interview_ai/core/di/injection.dart';

@lazySingleton
class InterviewRecorderService {
  CameraController? _cameraController;
  final FaceDetectorService _faceDetectorService = sl<FaceDetectorService>();
  final PoseDetectorService _poseDetectorService = sl<PoseDetectorService>();
  final ObjectDetectorService _objectDetectorService =
      sl<ObjectDetectorService>();

  bool _isBusy = false;
  double _currentAudioLevel = 0.0;

  CameraController? get cameraController => _cameraController;
  double get currentAudioLevel => _currentAudioLevel;

  Future<void> initialize() async {
    final cameras = await availableCameras();
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
  }

  void startImageStream(
    Function(InputImage inputImage, CameraImage cameraImage) onImage,
  ) {
    _cameraController?.startImageStream((image) async {
      // Mock audio level for now as camera plugin doesn't directly expose it during stream
      // In a real production app, we might use a separate audio recording plugin for levels
      _currentAudioLevel = math.Random().nextDouble();

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
      }
    }
  }

  Future<XFile?> stopVideoRecording() async {
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
    if (_cameraController != null) {
      if (_cameraController!.value.isStreamingImages) {
        await _cameraController!.stopImageStream();
      }
      if (_cameraController!.value.isRecordingVideo) {
        await _cameraController!.stopVideoRecording();
      }
      await _cameraController!.dispose();
      _cameraController = null;
    }
    _faceDetectorService.dispose();
    _poseDetectorService.dispose();
    _objectDetectorService.dispose();
  }
}
