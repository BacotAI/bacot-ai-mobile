import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:logarte/logarte.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_interview_ai/app/router/app_router.dart';
import 'package:smart_interview_ai/app/router/auth_guard.dart';
import 'package:smart_interview_ai/core/config/env.dart';
import 'package:smart_interview_ai/core/network/api_client.dart';
import 'package:smart_interview_ai/core/network/dio_api_client.dart';
import 'package:smart_interview_ai/core/network/interceptors/auth_interceptor.dart';
import 'package:smart_interview_ai/core/network/interceptors/logging_interceptor.dart';

@module
abstract class ServiceModule {
  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn();

  @preResolve
  @lazySingleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  Logarte get logarte => Logarte();

  @lazySingleton
  AuthGuard get authGuard => AuthGuard();

  @lazySingleton
  AppRouter appRouter(AuthGuard authGuard) => AppRouter(authGuard);

  @lazySingleton
  ApiClient apiClient(Logarte logarte) {
    final options = BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 120),
    );

    final dio = Dio(options);

    dio.interceptors.addAll([
      AuthInterceptor(),
      LogarteDioInterceptor(logarte),
    ]);

    if (kDebugMode) {
      dio.interceptors.add(LoggingInterceptor());
    }

    return DioApiClient(dio);
  }
}
