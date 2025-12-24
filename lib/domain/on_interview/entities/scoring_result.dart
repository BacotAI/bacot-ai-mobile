import 'package:equatable/equatable.dart';

class ScoringResult extends Equatable {
  final double eyeContactScore; // 0.0 to 1.0
  final Map<String, double> expressions; // e.g., {'smile': 0.8, 'serious': 0.2}
  final bool isPostureGood;
  final List<String> detectedDistractions; // e.g., ['phone', 'bottle']
  final String feedbackMessage;

  const ScoringResult({
    this.eyeContactScore = 0.0,
    this.expressions = const {},
    this.isPostureGood = true,
    this.detectedDistractions = const [],
    this.feedbackMessage = '',
  });

  @override
  List<Object?> get props => [
    eyeContactScore,
    expressions,
    isPostureGood,
    detectedDistractions,
    feedbackMessage,
  ];
}
