import 'package:get_it/get_it.dart';
import 'package:smart_interview_ai/features/sample/presentation/cubit/sample_cubit.dart';
import 'package:smart_interview_ai/features/pre_interview/presentation/cubit/pre_interview_cubit.dart';
import 'package:smart_interview_ai/features/on_interview/presentation/cubit/on_interview_cubit.dart';

abstract class BlocModule {
  static void init(GetIt sl) {
    sl.registerFactory(() => SampleCubit(repository: sl()));
    sl.registerFactory(() => PreInterviewCubit(repository: sl()));
    sl.registerFactory(() => OnInterviewCubit(recorderService: sl()));
  }
}
