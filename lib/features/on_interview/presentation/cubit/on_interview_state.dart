import 'package:equatable/equatable.dart';
import '../../domain/entities/scoring_result.dart';

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
  final int currentQuestionIndex;
  final int totalQuestions;
  final int elapsedSeconds;
  final int totalDuration;
  final bool canGoNext;
  final double audioLevel;
  final ScoringResult? lastScoringResult;

  const OnInterviewRecording({
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.elapsedSeconds,
    required this.totalDuration,
    required this.canGoNext,
    this.audioLevel = 0.0,
    this.lastScoringResult,
  });

  OnInterviewRecording copyWith({
    int? currentQuestionIndex,
    int? totalQuestions,
    int? elapsedSeconds,
    int? totalDuration,
    bool? canGoNext,
    double? audioLevel,
    ScoringResult? lastScoringResult,
  }) {
    return OnInterviewRecording(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      totalDuration: totalDuration ?? this.totalDuration,
      canGoNext: canGoNext ?? this.canGoNext,
      audioLevel: audioLevel ?? this.audioLevel,
      lastScoringResult: lastScoringResult ?? this.lastScoringResult,
    );
  }

  @override
  List<Object?> get props => [
    currentQuestionIndex,
    totalQuestions,
    elapsedSeconds,
    totalDuration,
    canGoNext,
    audioLevel,
    lastScoringResult,
  ];
}

class OnInterviewStepTransition extends OnInterviewState {
  final int fromIndex;
  final int toIndex;

  const OnInterviewStepTransition({
    required this.fromIndex,
    required this.toIndex,
  });

  @override
  List<Object?> get props => [fromIndex, toIndex];
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
