import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:smart_interview_ai/features/smart_camera/utils/camera_image_converter.dart';

class FaceDetectorService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true, // For smiling, blinking presence
    ),
  );

  Future<List<Face>> processImage(InputImage inputImage) async {
    try {
      return await _faceDetector.processImage(inputImage);
    } catch (e) {
      debugPrint('Face Detection Error: $e');
      return [];
    }
  }

  void dispose() {
    _faceDetector.close();
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
