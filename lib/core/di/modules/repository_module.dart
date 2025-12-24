import 'package:get_it/get_it.dart';
import 'package:smart_interview_ai/features/sample/data/repositories/sample_repository_impl.dart';
import 'package:smart_interview_ai/features/sample/domain/repositories/sample_repository.dart';
import 'package:smart_interview_ai/features/pre_interview/domain/repositories/pre_interview_repository.dart';
import 'package:smart_interview_ai/features/pre_interview/data/repositories/pre_interview_repository_impl.dart';

abstract class RepositoryModule {
  static void init(GetIt sl) {
    sl.registerFactory<SampleRepository>(
      () => SampleRepositoryImpl(apiClient: sl()),
    );
    sl.registerLazySingleton<PreInterviewRepository>(
      () => PreInterviewRepositoryImpl(),
    );
  }
}
