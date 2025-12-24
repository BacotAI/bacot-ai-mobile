part of 'on_interview_bloc.dart';

abstract class OnInterviewEvent extends Equatable {
  const OnInterviewEvent();

  @override
  List<Object?> get props => [];
}

class OnInterviewInitialized extends OnInterviewEvent {
  const OnInterviewInitialized();
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
