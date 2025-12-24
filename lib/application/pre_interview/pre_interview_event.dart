part of 'pre_interview_bloc.dart';

abstract class PreInterviewEvent extends Equatable {
  const PreInterviewEvent();

  @override
  List<Object?> get props => [];
}

class PreInterviewQuestionsRequested extends PreInterviewEvent {
  const PreInterviewQuestionsRequested();
}
