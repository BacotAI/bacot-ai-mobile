part of 'on_interview_bloc.dart';

abstract class OnInterviewEvent extends Equatable {
  const OnInterviewEvent();

  @override
  List<Object?> get props => [];
}

class OnInterviewInitialized extends OnInterviewEvent {
  final List<QuestionEntity> questions;
  const OnInterviewInitialized({required this.questions});

  @override
  List<Object?> get props => [questions];
}

class OnInterviewStarted extends OnInterviewEvent {
  const OnInterviewStarted();
}

class OnInterviewImageStreamProcessed extends OnInterviewEvent {
  final InputImage inputImage;
  final CameraImage cameraImage;

  const OnInterviewImageStreamProcessed(this.inputImage, this.cameraImage);

  @override
  List<Object?> get props => [inputImage, cameraImage];
}

class OnInterviewStopped extends OnInterviewEvent {
  const OnInterviewStopped();
}

class OnInterviewAudioLevelChanged extends OnInterviewEvent {
  final double level;
  const OnInterviewAudioLevelChanged(this.level);

  @override
  List<Object?> get props => [level];
}

class OnInterviewTimerTicked extends OnInterviewEvent {
  final int value;
  final bool isInitialCountdown;

  const OnInterviewTimerTicked(this.value, {this.isInitialCountdown = false});

  @override
  List<Object?> get props => [value, isInitialCountdown];
}

class OnInterviewNextQuestionRequested extends OnInterviewEvent {
  const OnInterviewNextQuestionRequested();
}

class OnInterviewTranscriptionStarted extends OnInterviewEvent {
  final int questionIndex;
  const OnInterviewTranscriptionStarted(this.questionIndex);

  @override
  List<Object?> get props => [questionIndex];
}

class OnInterviewTranscriptionCompleted extends OnInterviewEvent {
  final int questionIndex;
  final String text;
  const OnInterviewTranscriptionCompleted(this.questionIndex, this.text);

  @override
  List<Object?> get props => [questionIndex, text];
}

class OnInterviewTranscriptionFailed extends OnInterviewEvent {
  final int questionIndex;
  final String error;
  const OnInterviewTranscriptionFailed(this.questionIndex, this.error);

  @override
  List<Object?> get props => [questionIndex, error];
}
