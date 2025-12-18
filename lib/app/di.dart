import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_interview_ai/core/config/env.dart';
import 'package:smart_interview_ai/core/network/api_client.dart';
import 'package:smart_interview_ai/core/network/dio_api_client.dart';
import 'package:smart_interview_ai/core/network/interceptors/auth_interceptor.dart';
import 'package:smart_interview_ai/core/network/interceptors/logging_interceptor.dart';
import 'package:smart_interview_ai/features/auth/domain/auth_repository.dart';
import 'package:smart_interview_ai/features/sample/data/repositories/sample_repository_impl.dart';
import 'package:smart_interview_ai/features/sample/domain/repositories/sample_repository.dart';
import 'package:smart_interview_ai/features/sample/presentation/cubit/sample_cubit.dart';
import 'package:smart_interview_ai/features/pre_interview/domain/repositories/pre_interview_repository.dart';
import 'package:smart_interview_ai/features/pre_interview/data/repositories/pre_interview_repository_impl.dart';
import 'package:smart_interview_ai/features/pre_interview/presentation/cubit/pre_interview_cubit.dart';
import 'package:smart_interview_ai/features/on_interview/logic/interview_recorder_service.dart';
import 'package:smart_interview_ai/features/on_interview/presentation/cubit/on_interview_cubit.dart';

final sl = GetIt.instance;

class DI {
  static Future<void> init() async {
    // 1. Environment
    await dotenv.load(fileName: '.env');

    // 2. Core (Network)
    sl.registerLazySingleton<ApiClient>(() => _buildApiClient());

    // 3. Features - Sample
    // Repositories
    sl.registerFactory<SampleRepository>(
      () => SampleRepositoryImpl(apiClient: sl()),
    );
    // Cubit
    sl.registerFactory(() => SampleCubit(repository: sl()));

    // 4. Features - Pre-Interview
    // Repositories
    sl.registerLazySingleton<PreInterviewRepository>(
      () => PreInterviewRepositoryImpl(),
    );
    // Cubit
    sl.registerFactory(() => PreInterviewCubit(repository: sl()));

    // 5. Features - On-Interview
    // Services (Singleton as it may hold camera resources)
    sl.registerLazySingleton<InterviewRecorderService>(
      () => InterviewRecorderService(),
    );
    // Cubit
    sl.registerFactory(() => OnInterviewCubit(recorderService: sl()));
  }

  static ApiClient _buildApiClient() {
    final options = BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 120),
    );
    final dio = Dio(options);
    dio.interceptors.add(AuthInterceptor());
    if (kDebugMode) {
      dio.interceptors.add(LoggingInterceptor());
    }
    return DioApiClient(dio);
  }

  // Legacy / Helpers
  static Future<void> initEnv() async => await dotenv.load(fileName: '.env');

  // TODO: Migrate AuthRepository to GetIt fully
  static late final AuthRepository authRepository;
}
