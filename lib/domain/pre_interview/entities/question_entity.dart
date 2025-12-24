import 'package:equatable/equatable.dart';

enum QuestionDifficulty { easy, tricky, hard }

class QuestionEntity extends Equatable {
  final String id;
  final String text;
  final String hrInsight;
  final QuestionDifficulty difficulty;
  final int estimatedDurationSeconds;
  final String communityStats;
  final List<String> powerWords;

  const QuestionEntity({
    required this.id,
    required this.text,
    required this.hrInsight,
    required this.difficulty,
    required this.estimatedDurationSeconds,
    required this.communityStats,
    required this.powerWords,
  });

  @override
  List<Object?> get props => [
    id,
    text,
    hrInsight,
    difficulty,
    estimatedDurationSeconds,
    communityStats,
    powerWords,
  ];
}
