import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/pre_interview_repository.dart';
import 'pre_interview_state.dart';

class PreInterviewCubit extends Cubit<PreInterviewState> {
  final PreInterviewRepository repository;

  PreInterviewCubit({required this.repository}) : super(PreInterviewInitial());

  Future<void> loadQuestions() async {
    emit(PreInterviewLoading());
    try {
      final questions = await repository.getQuestions();
      emit(PreInterviewLoaded(questions));
    } catch (e) {
      emit(PreInterviewError(e.toString()));
    }
  }
}
