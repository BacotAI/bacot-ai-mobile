part of 'on_interview_bloc.dart';

abstract class OnInterviewState extends Equatable {
  const OnInterviewState();

  @override
  List<Object?> get props => [];
}

class OnInterviewInitial extends OnInterviewState {}

class OnInterviewLoading extends OnInterviewState {}

class OnInterviewReady extends OnInterviewState {}

class OnInterviewCountdown extends OnInterviewState {
  final int validDuration;

  const OnInterviewCountdown(this.validDuration);

  @override
  List<Object?> get props => [validDuration];
}

class OnInterviewRecording extends OnInterviewState {
  final int currentQuestionIndex;
  final int totalQuestions;
  final int remainingSeconds;
  final int totalDuration;
  final bool canGoNext;
  final double audioLevel;
  final ScoringResult? lastScoringResult;

  const OnInterviewRecording({
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.remainingSeconds,
    required this.totalDuration,
    required this.canGoNext,
    this.audioLevel = 0.0,
    this.lastScoringResult,
    this.transcriptionStatuses = const {},
    this.transcriptions = const {},
  });

  final Map<int, TranscriptionStatus> transcriptionStatuses;
  final Map<int, String> transcriptions;

  OnInterviewRecording copyWith({
    int? currentQuestionIndex,
    int? totalQuestions,
    int? remainingSeconds,
    int? totalDuration,
    bool? canGoNext,
    double? audioLevel,
    ScoringResult? lastScoringResult,
    Map<int, TranscriptionStatus>? transcriptionStatuses,
    Map<int, String>? transcriptions,
  }) {
    return OnInterviewRecording(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalDuration: totalDuration ?? this.totalDuration,
      canGoNext: canGoNext ?? this.canGoNext,
      audioLevel: audioLevel ?? this.audioLevel,
      lastScoringResult: lastScoringResult ?? this.lastScoringResult,
      transcriptionStatuses:
          transcriptionStatuses ?? this.transcriptionStatuses,
      transcriptions: transcriptions ?? this.transcriptions,
    );
  }

  @override
  List<Object?> get props => [
    currentQuestionIndex,
    totalQuestions,
    remainingSeconds,
    totalDuration,
    canGoNext,
    audioLevel,
    lastScoringResult,
    transcriptionStatuses,
    transcriptions,
  ];
}

class OnInterviewStepTransition extends OnInterviewState {
  final int fromIndex;
  final int toIndex;
  final int totalQuestions;
  final double audioLevel;

  const OnInterviewStepTransition({
    required this.fromIndex,
    required this.toIndex,
    required this.totalQuestions,
    this.audioLevel = 0.0,
    this.transcriptionStatuses = const {},
    this.transcriptions = const {},
  });

  final Map<int, TranscriptionStatus> transcriptionStatuses;
  final Map<int, String> transcriptions;

  @override
  List<Object?> get props => [
    fromIndex,
    toIndex,
    totalQuestions,
    audioLevel,
    transcriptionStatuses,
    transcriptions,
  ];
}

class OnInterviewProcessing extends OnInterviewState {
  final Map<int, TranscriptionStatus> transcriptionStatuses;

  const OnInterviewProcessing({this.transcriptionStatuses = const {}});

  @override
  List<Object?> get props => [transcriptionStatuses];
}

class OnInterviewFinished extends OnInterviewState {
  final ScoringResult finalResult;
  final List<String> videoPaths;
  final Map<int, TranscriptionStatus> transcriptionStatuses;
  final Map<int, String> transcriptions;

  const OnInterviewFinished(
    this.finalResult, {
    this.videoPaths = const [],
    this.transcriptionStatuses = const {},
    this.transcriptions = const {},
  });

  @override
  List<Object?> get props => [
    finalResult,
    videoPaths,
    transcriptionStatuses,
    transcriptions,
  ];
}

class OnInterviewError extends OnInterviewState {
  final String message;

  const OnInterviewError(this.message);

  @override
  List<Object?> get props => [message];
}
