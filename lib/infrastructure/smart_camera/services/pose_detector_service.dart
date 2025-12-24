import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'package:smart_interview_ai/infrastructure/smart_camera/utils/camera_image_converter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PoseDetectorService {
  final PoseDetector _poseDetector = PoseDetector(
    options: PoseDetectorOptions(),
  );

  Future<List<Pose>> processImage(InputImage inputImage) async {
    try {
      return await _poseDetector.processImage(inputImage);
    } catch (e) {
      debugPrint('Pose Detection Error: $e');
      return [];
    }
  }

  void dispose() {
    _poseDetector.close();
  }

  InputImage? inputImageFromCameraImage({
    required CameraImage image,
    required CameraDescription camera,
    required DeviceOrientation deviceOrientation,
  }) {
    return CameraImageConverter.inputImageFromCameraImage(
      image: image,
      camera: camera,
      deviceOrientation: deviceOrientation,
    );
  }
}
