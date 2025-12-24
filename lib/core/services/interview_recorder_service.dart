import 'dart:io';
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

  CameraController? get cameraController => _cameraController;

  Future<void> initialize() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium, // Balance quality and performance
      enableAudio: true, // We need audio for the interview
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
    await _cameraController?.stopImageStream();
    await _cameraController?.dispose();
    _faceDetectorService.dispose();
    _poseDetectorService.dispose();
    _objectDetectorService.dispose();
  }
}
