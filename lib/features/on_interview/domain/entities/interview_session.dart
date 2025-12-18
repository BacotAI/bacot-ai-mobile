import 'package:equatable/equatable.dart';

enum InterviewStatus { countdown, recording, processing, review }

class InterviewSession extends Equatable {
  final String id;
  final String questionId;
  final DateTime startTime;
  final InterviewStatus status;

  const InterviewSession({
    required this.id,
    required this.questionId,
    required this.startTime,
    required this.status,
  });

  @override
  List<Object?> get props => [id, questionId, startTime, status];

  InterviewSession copyWith({
    String? id,
    String? questionId,
    DateTime? startTime,
    InterviewStatus? status,
  }) {
    return InterviewSession(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      startTime: startTime ?? this.startTime,
      status: status ?? this.status,
    );
  }
}
