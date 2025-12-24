import '../entities/question_entity.dart';

abstract class PreInterviewRepository {
  Future<List<QuestionEntity>> getQuestions();
}
