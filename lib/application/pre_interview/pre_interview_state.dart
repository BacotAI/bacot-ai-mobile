part of 'pre_interview_bloc.dart';

abstract class PreInterviewState extends Equatable {
  const PreInterviewState();

  @override
  List<Object?> get props => [];
}

class PreInterviewInitial extends PreInterviewState {}

class PreInterviewLoading extends PreInterviewState {}

class PreInterviewLoaded extends PreInterviewState {
  final List<QuestionEntity> questions;

  const PreInterviewLoaded(this.questions);

  @override
  List<Object?> get props => [questions];
}

class PreInterviewError extends PreInterviewState {
  final String message;

  const PreInterviewError(this.message);

  @override
  List<Object?> get props => [message];
}
