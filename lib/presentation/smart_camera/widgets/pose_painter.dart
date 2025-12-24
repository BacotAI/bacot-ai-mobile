import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:smart_interview_ai/infrastructure/smart_camera/logic/posture_validator.dart';

class PosePainter extends CustomPainter {
  PosePainter({
    required this.poses,
    required this.imageSize,
    required this.rotation,
    required this.cameraLensDirection,
    required this.validationStatus,
  });

  final List<Pose> poses;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;
  final PostureValidationStatus validationStatus;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw Body Silhouette Guideline
    _drawBodySilhouette(canvas, size);

    if (poses.isEmpty) return;

    final Pose pose = poses.first;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = _getColorForStatus().withValues(alpha: 0.7);

    // Draw key landmarks
    final landmarks = pose.landmarks.values.toList();
    for (final landmark in landmarks) {
      // ... existing translation ...
      final offset = _translate(
        landmark.x,
        landmark.y,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );

      if (landmark.type == PoseLandmarkType.leftShoulder ||
          landmark.type == PoseLandmarkType.rightShoulder) {
        final shoulderPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.orange;
        canvas.drawCircle(offset, 7, shoulderPaint);
      } else {
        canvas.drawCircle(offset, 5, paint);
      }
    }
  }

  void _drawBodySilhouette(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _getColorForStatus()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final path = Path();
    final centerX = size.width / 2;

    // Solution: Massive head, sitting lower in the frame.
    final headRadius = size.width * 0.24; // > 50% width diameter

    // Start lower to push everything down
    final startY = size.height * 0.2;
    final headCenterY = startY + headRadius;

    // Head
    path.addOval(
      Rect.fromCenter(
        center: Offset(centerX, headCenterY),
        width: headRadius * 2.0,
        height: headRadius * 2.6,
      ),
    );

    // Shoulders and Body
    final neckWidth = headRadius * 0.45;
    // Lower shoulders slightly based on feedback (was 0.8, now 0.9)
    final shoulderTopY = headCenterY + headRadius * 1.3;

    final shoulderWidth = size.width * 0.5;
    final bodyBottom = size.height;

    path.moveTo(centerX - neckWidth, shoulderTopY);

    // Adjust slope
    final controlPointX = centerX - shoulderWidth * 0.6;
    final controlPointY = shoulderTopY + 15; // Slightly curve down start
    final shoulderEndPointX = centerX - shoulderWidth;
    final shoulderEndPointY = shoulderTopY + 80; // Moderate slope

    // Left shoulder slope
    path.quadraticBezierTo(
      controlPointX,
      controlPointY,
      shoulderEndPointX,
      shoulderEndPointY,
    );

    // Left side down
    path.lineTo(shoulderEndPointX, bodyBottom);

    // Bottom
    path.lineTo(centerX + shoulderWidth, bodyBottom);

    // Right side up
    path.lineTo(centerX + shoulderWidth, shoulderEndPointY);

    // Right shoulder slope
    path.quadraticBezierTo(
      centerX + shoulderWidth * 0.6,
      controlPointY,
      centerX + neckWidth,
      shoulderTopY,
    );

    canvas.drawPath(path, paint);
  }

  Color _getColorForStatus() {
    switch (validationStatus) {
      case PostureValidationStatus.aligned:
        return Colors.green;
      case PostureValidationStatus.notDetecting:
        return Colors.blue;
      case PostureValidationStatus.headNotAligned:
        return Colors.redAccent;
      case PostureValidationStatus.shouldersNotAligned:
        return Colors.red;
      default:
        return Colors.red;
    }
  }

  Offset _translate(
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

    // 5. Handle Mirroring (Front Camera)
    if (cameraLensDirection == CameraLensDirection.front) {
      screenX = screenSize.width - screenX;
    }

    return Offset(screenX, screenY);
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.poses != poses ||
        oldDelegate.validationStatus != validationStatus;
  }
}
