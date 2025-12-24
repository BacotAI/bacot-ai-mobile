import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_interview_ai/domain/pre_interview/entities/question_entity.dart';
import 'package:smart_interview_ai/domain/pre_interview/repositories/pre_interview_repository.dart';

part 'pre_interview_event.dart';
part 'pre_interview_state.dart';

@injectable
class PreInterviewBloc extends Bloc<PreInterviewEvent, PreInterviewState> {
  final PreInterviewRepository _repository;

  PreInterviewBloc(this._repository) : super(PreInterviewInitial()) {
    on<PreInterviewQuestionsRequested>(_onQuestionsRequested);
  }

  FutureOr<void> _onQuestionsRequested(
    PreInterviewQuestionsRequested event,
    Emitter<PreInterviewState> emit,
  ) async {
    emit(PreInterviewLoading());
    try {
      final questions = await _repository.getQuestions();
      emit(PreInterviewLoaded(questions));
    } catch (e) {
      emit(PreInterviewError(e.toString()));
    }
  }
}
