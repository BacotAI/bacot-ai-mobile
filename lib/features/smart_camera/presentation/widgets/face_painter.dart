import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:smart_interview_ai/features/smart_camera/presentation/widgets/pose_painter.dart'; // Removed unused import

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  FacePainter({
    required this.faces,
    required this.imageSize,
    required this.rotation,
    required this.cameraLensDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.green;

    final Paint landmarkPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0
      ..color = Colors.yellow;

    for (final Face face in faces) {
      final rect = face.boundingBox;
      final topLeft = _translate(
        rect.left,
        rect.top,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final bottomRight = _translate(
        rect.right,
        rect.bottom,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );

      canvas.drawRect(Rect.fromPoints(topLeft, bottomRight), paint);

      for (final landmark in face.landmarks.values) {
        if (landmark != null) {
          final offset = _translate(
            landmark.position.x.toDouble(),
            landmark.position.y.toDouble(),
            size,
            imageSize,
            rotation,
            cameraLensDirection,
          );
          canvas.drawCircle(offset, 3, landmarkPaint);
        }
      }

      final contourTypes = [
        FaceContourType.upperLipTop,
        FaceContourType.upperLipBottom,
        FaceContourType.lowerLipTop,
        FaceContourType.lowerLipBottom,
        FaceContourType.face,
      ];

      for (final type in contourTypes) {
        final contour = face.contours[type];
        if (contour != null) {
          for (final point in contour.points) {
            final offset = _translate(
              point.x.toDouble(),
              point.y.toDouble(),
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            );
            canvas.drawCircle(offset, 1, paint);
          }
        }
      }
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

    final double scaleX = screenSize.width / imageHeight;
    final double scaleY = screenSize.height / imageWidth;
    final double scale = scaleX > scaleY ? scaleX : scaleY;

    double targetX = x;
    double targetY = y;
    double screenX = targetX * scale;
    double screenY = targetY * scale;

    final double overflowX = (imageHeight * scale) - screenSize.width;
    final double overflowY = (imageWidth * scale) - screenSize.height;

    screenX -= overflowX / 2;
    screenY -= overflowY / 2;

    if (cameraLensDirection == CameraLensDirection.front) {
      screenX = screenSize.width - screenX;
    }

    return Offset(screenX, screenY);
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return oldDelegate.faces != faces ||
        oldDelegate.imageSize != imageSize ||
        oldDelegate.rotation != rotation ||
        oldDelegate.cameraLensDirection != cameraLensDirection;
  }
}
