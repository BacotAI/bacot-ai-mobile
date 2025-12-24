part of 'on_interview_bloc.dart';

abstract class OnInterviewState extends Equatable {
  const OnInterviewState();

  @override
  List<Object?> get props => [];
}

class OnInterviewInitial extends OnInterviewState {}

class OnInterviewLoading extends OnInterviewState {}

class OnInterviewCountdown extends OnInterviewState {
  final int validDuration;

  const OnInterviewCountdown(this.validDuration);

  @override
  List<Object?> get props => [validDuration];
}

class OnInterviewRecording extends OnInterviewState {
  final int elapsedSeconds;
  final int totalDuration;
  final ScoringResult? lastScoringResult;

  const OnInterviewRecording({
    required this.elapsedSeconds,
    required this.totalDuration,
    this.lastScoringResult,
  });

  @override
  List<Object?> get props => [elapsedSeconds, totalDuration, lastScoringResult];
}

class OnInterviewProcessing extends OnInterviewState {}

class OnInterviewFinished extends OnInterviewState {
  final ScoringResult finalResult;

  const OnInterviewFinished(this.finalResult);

  @override
  List<Object?> get props => [finalResult];
}

class OnInterviewError extends OnInterviewState {
  final String message;

  const OnInterviewError(this.message);

  @override
  List<Object?> get props => [message];
}
