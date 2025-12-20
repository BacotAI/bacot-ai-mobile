import 'dart:ui';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:smart_interview_ai/features/smart_camera/services/object_detector_service.dart';
import '../../features/on_interview/domain/entities/scoring_result.dart';

class ScoringCalculator {
  /// Calculates scores based on available detection data.
  ///
  /// [face] - The primary face detected.
  /// [poses] - List of poses (we usually care about the first one).
  /// [objectResult] - Result from object detection (masks/hats/etc).
  /// [imageSize] - Size of the camera image for posture validation.
  /// [screenSize] - Size of the screen/preview for posture validation.
  static ScoringResult calculate({
    Face? face,
    List<Pose>? poses,
    ProhibitedItemResult? objectResult,
    Size? imageSize,
    Size? screenSize,
  }) {
    // 1. Eye Contact Calculation
    // Heuristic: If headEulerAngleY (yaw) and headEulerAngleZ (roll) are close to 0, user is looking at camera.
    // Ideally, we primarily check yaw.
    double eyeContact = 0.0;
    String feedback = "";

    if (face != null) {
      final double yaw = face.headEulerAngleY ?? 0; // Left/Right
      final double tilt = face.headEulerAngleX ?? 0; // Up/Down

      // Thresholds for "looking at camera"
      // Yaw: +/- 10 degrees
      // Tilt: +/- 15 degrees
      final bool isLookingAtCamera = (yaw.abs() < 12) && (tilt.abs() < 15);
      eyeContact = isLookingAtCamera ? 1.0 : 0.2;

      if (!isLookingAtCamera) {
        if (yaw.abs() > 12) {
          feedback = "Lihat ke kamera, jangan ke samping.";
        } else if (tilt.abs() > 15) {
          feedback = "Angkat wajah Anda sedikit.";
        }
      }
    } else {
      feedback = "Wajah tidak terdeteksi.";
    }

    // 2. Expressions
    final Map<String, double> expressions = {};
    if (face != null) {
      if (face.smilingProbability != null) {
        expressions['smile'] = face.smilingProbability!;
      }
      // ML Kit doesn't give "serious" directly, but low smile + open eyes might imply it.
      // We can add more custom heuristics here if needed.
    }

    // 3. Posture
    bool isPostureGood = true;
    if (poses != null &&
        poses.isNotEmpty &&
        imageSize != null &&
        screenSize != null) {
      // We use the existing PostureValidator but adapted for boolean check
      // Ideally we reuse the enum logic.
      // For now, let's assume if it returns 'aligned' it's good.
      // Note: We need to pass valid params. Since this is non-contextual, we simplify.
      // Simplified check: Are shoulders level?
      final pose = poses.first;
      final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
      final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];

      if (leftShoulder != null && rightShoulder != null) {
        final double slope = (rightShoulder.y - leftShoulder.y).abs();
        if (slope > 40) {
          // Arbitrary threshold for tilt
          isPostureGood = false;
          if (feedback.isEmpty) feedback = "Bahu Anda miring.";
        }
      }
    }

    // 4. Distractions (Objects)
    final List<String> distractions = [];
    if (objectResult != null) {
      if (objectResult.hasMask) distractions.add('Masker');
      if (objectResult.hasCap) distractions.add('Topi');
      if (distractions.isNotEmpty && feedback.isEmpty) {
        feedback = "Lepaskan ${distractions.join(' & ')}.";
      }
    }

    return ScoringResult(
      eyeContactScore: eyeContact,
      expressions: expressions,
      isPostureGood: isPostureGood,
      detectedDistractions: distractions,
      feedbackMessage: feedback,
    );
  }
}
