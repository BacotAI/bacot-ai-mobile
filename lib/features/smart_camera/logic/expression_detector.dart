import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:smart_interview_ai/features/smart_camera/models/expression_data.dart';
import 'dart:math';

class ExpressionDetector {
  static ExpressionData detect(Face face) {
    // 1. Smile
    final double smile = face.smilingProbability ?? 0.0;

    // 2. Serious
    // Heuristic: Low smile + eyes open + neutral head position
    // If smile is high, serious is low.
    // If eyes are closed, maybe not serious (or sleepy).
    final double leftEye = face.leftEyeOpenProbability ?? 0.5;
    final double rightEye = face.rightEyeOpenProbability ?? 0.5;
    final double avgEyeOpen = (leftEye + rightEye) / 2;

    // Serious is high when not smiling and eyes are alert.
    double serious = (1.0 - smile) * avgEyeOpen;
    // Boost serious if looking mostly straight

    // 3. Interest
    // Heuristic: Head Euler Angle Y (Yaw) close to 0 (looking at camera)
    // and Angle Z (Tilt) close to 0.
    final double rotY = (face.headEulerAngleY ?? 0.0).abs(); // Yaw
    final double rotZ = (face.headEulerAngleZ ?? 0.0).abs(); // Tilt

    // Normalize angles. Assuming > 45 degrees is "looking away/disinterested"
    double interestY = (45.0 - min(rotY, 45.0)) / 45.0;
    double interestZ = (45.0 - min(rotZ, 45.0)) / 45.0;

    // Combine. Weight Yaw more as it indicates looking at the screen.
    double interest = (interestY * 0.7) + (interestZ * 0.3);

    // 4. Expressiveness
    // Heuristic: Combination of smile intensity and other facial movements.
    // We can use a mix of smile and eye open variance, or just smile for now + head tilt.
    // If checking for "expressiveness", maybe a slight head tilt is good?
    // Let's model it as: Max(smile, serious) + some dynamic factor.
    // Or: average of all probabilities.
    // Let's try: (smile + (1-serious) + interest) / 3 but simpler:
    double expressiveness =
        (smile + (avgEyeOpen > 0.8 ? 0.3 : 0.0) + (rotZ > 5 ? 0.2 : 0.0));
    expressiveness = min(expressiveness, 1.0);

    return ExpressionData(
      smile: (smile * 100).clamp(0, 100),
      serious: (serious * 100).clamp(0, 100),
      interest: (interest * 100).clamp(0, 100),
      expressiveness: (expressiveness * 100).clamp(0, 100),
    );
  }
}
