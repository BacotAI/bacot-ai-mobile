import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logarte/logarte.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_interview_ai/app/router/app_router.dart';
import 'package:smart_interview_ai/app/router/auth_guard.dart';
import 'package:smart_interview_ai/core/config/env.dart';
import 'package:smart_interview_ai/core/network/api_client.dart';
import 'package:smart_interview_ai/core/network/dio_api_client.dart';
import 'package:smart_interview_ai/core/network/interceptors/auth_interceptor.dart';
import 'package:smart_interview_ai/core/network/interceptors/logging_interceptor.dart';
import 'package:smart_interview_ai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smart_interview_ai/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_interview_ai/features/home/presentation/cubit/home_cubit.dart';
import 'package:smart_interview_ai/features/sample/data/repositories/sample_repository_impl.dart';
import 'package:smart_interview_ai/features/sample/domain/repositories/sample_repository.dart';
import 'package:smart_interview_ai/features/sample/presentation/cubit/sample_cubit.dart';
import 'package:smart_interview_ai/features/pre_interview/domain/repositories/pre_interview_repository.dart';
import 'package:smart_interview_ai/features/pre_interview/data/repositories/pre_interview_repository_impl.dart';
import 'package:smart_interview_ai/features/pre_interview/presentation/cubit/pre_interview_cubit.dart';
import 'package:smart_interview_ai/core/services/interview_recorder_service.dart';
import 'package:smart_interview_ai/features/on_interview/presentation/cubit/on_interview_cubit.dart';

final sl = GetIt.instance;

class DI {
  static late final AuthRepository authRepository;
  static late final AuthGuard authGuard;
  static late final AppRouter appRouter;

  static Future<void> init() async {
    await dotenv.load(fileName: '.env');

    sl.registerLazySingleton<ApiClient>(() => _buildApiClient());
    sl.registerFactory<SampleRepository>(
      () => SampleRepositoryImpl(apiClient: sl()),
    );
    authGuard = AuthGuard();
    appRouter = AppRouter(authGuard);
    sl.registerFactory(() => SampleCubit(repository: sl()));
    sl.registerLazySingleton<PreInterviewRepository>(
      () => PreInterviewRepositoryImpl(),
    );
    sl.registerFactory(() => PreInterviewCubit(repository: sl()));
    sl.registerLazySingleton<InterviewRecorderService>(
      () => InterviewRecorderService(),
    );
    sl.registerFactory(() => OnInterviewCubit(recorderService: sl()));
    sl.registerLazySingleton<Logarte>(
      () => Logarte(
        password: 'tulkun-tul',
        onShare: (content) {
          SharePlus.instance.share(
            ShareParams(
              text: content,
              title: 'Network Request',
              excludedCupertinoActivities: [CupertinoActivityType.airDrop],
            ),
          );
        },
        onExport: (allLogs) {
          SharePlus.instance.share(
            ShareParams(
              text: allLogs,
              title: 'Network Request',
              excludedCupertinoActivities: [CupertinoActivityType.airDrop],
            ),
          );
        },
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => prefs);

    sl.registerLazySingleton<GoogleSignIn>(
      () => GoogleSignIn(scopes: ['email']),
    );
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl<GoogleSignIn>(), sl<SharedPreferences>()),
    );
    sl.registerFactory<HomeCubit>(() => HomeCubit(sl<AuthRepository>()));
  }

  static ApiClient _buildApiClient() {
    final options = BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 120),
    );
    final dio = Dio(options);
    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(LogarteDioInterceptor(sl<Logarte>()));

    if (kDebugMode) {
      dio.interceptors.add(LoggingInterceptor());
    }
    return DioApiClient(dio);
  }

  static Future<void> initEnv() async => await dotenv.load(fileName: '.env');
}
