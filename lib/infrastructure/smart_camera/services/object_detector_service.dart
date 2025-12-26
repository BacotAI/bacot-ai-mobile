import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:smart_interview_ai/infrastructure/smart_camera/utils/camera_image_converter.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/helper/log_helper.dart';

import 'package:injectable/injectable.dart';

class ProhibitedItemResult {
  final bool hasMask;
  final bool hasCap;

  ProhibitedItemResult({required this.hasMask, required this.hasCap});
}

@lazySingleton
class ObjectDetectorService {
  ObjectDetector? _maskDetector;
  ImageLabeler? _hatDetector;
  bool _isProcessing = false;

  ObjectDetectorService() {
    _initializeDetectors();
  }

  Future<void> _initializeDetectors() async {
    await _initializeCapDetector();
  }

  Future<void> _initializeCapDetector() async {
    final hatOptions = ImageLabelerOptions(confidenceThreshold: 0.5);
    _hatDetector = ImageLabeler(options: hatOptions);
  }

  Future<String> _copyAssetToFile(String assetPath, String filename) async {
    final bytes = await rootBundle.load(assetPath);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
    );

    return file.path;
  }

  Future<ProhibitedItemResult?> processImage(InputImage inputImage) async {
    if (_isProcessing || _hatDetector == null) {
      return null;
    }
    _isProcessing = true;

    try {
      final hatResult = await _hatDetector!.processImage(inputImage);
      final hasCap = _processCapLabels(hatResult);

      // final maskObjects = await _maskDetector!.processImage(inputImage);
      // final hasMask = _processMaskObjects(maskObjects);

      return ProhibitedItemResult(hasMask: false, hasCap: hasCap);
    } catch (e) {
      Log.error('Error detecting objects: $e');
      return null;
    } finally {
      _isProcessing = false;
    }
  }

  bool _processMaskObjects(List<DetectedObject> maskObjects) {
    for (final object in maskObjects) {
      for (final label in object.labels) {
        final text = label.text.toLowerCase();
        if ((text.contains("mask") && !text.contains("no")) || text == "1") {
          return true;
        }
      }
    }
    return false;
  }

  bool _processCapLabels(List<ImageLabel> hatLabels) {
    final prohibitedHeadwear = ["cap", "helmet", "beanie", "visor"];
    for (final label in hatLabels) {
      final text = label.label.toLowerCase();
      if (label.confidence > 0.6) {
        for (final item in prohibitedHeadwear) {
          if (text.contains(item)) {
            return true;
          }
        }
      }
    }
    return false;
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

  void dispose() {
    _maskDetector?.close();
    _hatDetector?.close();
  }
}
