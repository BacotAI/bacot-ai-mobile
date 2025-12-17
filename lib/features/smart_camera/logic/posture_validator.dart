import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'dart:math' as math;

enum PostureValidationStatus {
  aligned,
  shouldersNotAligned,
  tooFar,
  tooClose,
  notDetecting,
  misaligned, // Generic
  headNotAligned,
}

class PostureValidator {
  static PostureValidationStatus validate({
    required List<Pose> poses,
    required Size imageSize,
    required Size screenSize,
    required InputImageRotation rotation,
    required CameraLensDirection cameraLensDirection,
  }) {
    if (poses.isEmpty) return PostureValidationStatus.notDetecting;

    final pose = poses.first;
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
    final nose = pose.landmarks[PoseLandmarkType.nose];

    if (leftShoulder == null || rightShoulder == null || nose == null) {
      return PostureValidationStatus.notDetecting;
    }

    final headValidationStatus = _validateHeadPosition(
      nose: nose,
      imageSize: imageSize,
      rotation: rotation,
      cameraLensDirection: cameraLensDirection,
      screenSize: screenSize,
    );

    if (headValidationStatus != null) {
      return headValidationStatus;
    }

    final detailedValidationStatus = _validateShoulderPosition(
      leftShoulder: leftShoulder,
      rightShoulder: rightShoulder,
      imageSize: imageSize,
      rotation: rotation,
      cameraLensDirection: cameraLensDirection,
      screenSize: screenSize,
    );

    if (detailedValidationStatus != null) {
      return detailedValidationStatus;
    }

    return PostureValidationStatus.aligned;
  }

  static PostureValidationStatus? _validateHeadPosition({
    required PoseLandmark nose,
    required Size screenSize,
    required Size imageSize,
    required InputImageRotation rotation,
    required CameraLensDirection cameraLensDirection,
  }) {
    final nosePoint = _translate(
      nose.x,
      nose.y,
      screenSize,
      imageSize,
      rotation,
      cameraLensDirection,
    );

    final headRadius = screenSize.width * 0.28;

    final guidelineHeadCenterY = screenSize.height * 0.15 + headRadius;
    final guidelineCenterX = screenSize.width / 2;

    final dx = nosePoint.dx - guidelineCenterX;
    final dy = nosePoint.dy - guidelineHeadCenterY;
    final distance = math.sqrt(dx * dx + dy * dy);

    if (distance > headRadius) {
      return PostureValidationStatus.headNotAligned;
    }

    return null;
  }

  static PostureValidationStatus? _validateShoulderPosition({
    required PoseLandmark leftShoulder,
    required PoseLandmark rightShoulder,
    required Size screenSize,
    required Size imageSize,
    required InputImageRotation rotation,
    required CameraLensDirection cameraLensDirection,
  }) {
    final leftShoulderPoint = _translate(
      leftShoulder.x,
      leftShoulder.y,
      screenSize,
      imageSize,
      rotation,
      cameraLensDirection,
    );
    final rightShoulderPoint = _translate(
      rightShoulder.x,
      rightShoulder.y,
      screenSize,
      imageSize,
      rotation,
      cameraLensDirection,
    );

    final yDiff = (leftShoulderPoint.dy - rightShoulderPoint.dy).abs();

    if (yDiff > screenSize.height * 0.05) {
      return PostureValidationStatus.shouldersNotAligned;
    }

    // 1. Reconstruct Silhouette Geometry (Must match PosePainter)
    final headRadius = screenSize.width * 0.24;
    final startY = screenSize.height * 0.2;
    final headCenterY = startY + headRadius;

    // Shoulder Y targets
    final shoulderTopY = headCenterY + headRadius * 2.5;
    final minShoulderY = shoulderTopY - (headRadius * 0.5);

    bool isLeftShoulderHeightValid = leftShoulderPoint.dy >= minShoulderY;
    bool isRightShoulderHeightValid = rightShoulderPoint.dy >= minShoulderY;

    if (!isLeftShoulderHeightValid || !isRightShoulderHeightValid) {
      return PostureValidationStatus.shouldersNotAligned;
    }

    return null;
  }

  static Offset _translate(
    double x,
    double y,
    Size screenSize,
    Size imageSize,
    InputImageRotation rotation,
    CameraLensDirection cameraLensDirection,
  ) {
    double imageHeight = imageSize.height;
    double imageWidth = imageSize.width;

    // 2. Calculate Scale for BoxFit.cover
    final double scaleX = screenSize.width / imageHeight;
    final double scaleY = screenSize.height / imageWidth;
    final double scale = scaleX > scaleY
        ? scaleX
        : scaleY; // max(scaleX, scaleY) implies cover

    // 3. Transform Coordinates
    double targetX = x;
    double targetY = y;

    // Now scale to screen
    double screenX = targetX * scale;
    double screenY = targetY * scale;

    // 4. Center the image (Account for overflow)
    // The rendered image is larger than screen. We need to shift it so it's centered.
    final double overflowX = (imageHeight * scale) - screenSize.width;
    final double overflowY = (imageWidth * scale) - screenSize.height;

    screenX -= overflowX / 2;
    screenY -= overflowY / 2;

    if (cameraLensDirection == CameraLensDirection.front) {
      screenX = screenSize.width - screenX;
    }

    return Offset(screenX, screenY);
  }
}
