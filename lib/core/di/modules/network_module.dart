import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logarte/logarte.dart';
import 'package:smart_interview_ai/core/config/env.dart';
import 'package:smart_interview_ai/core/network/api_client.dart';
import 'package:smart_interview_ai/core/network/dio_api_client.dart';
import 'package:smart_interview_ai/core/network/interceptors/auth_interceptor.dart';
import 'package:smart_interview_ai/core/network/interceptors/logging_interceptor.dart';

abstract class NetworkModule {
  static void init(GetIt sl) {
    sl.registerLazySingleton<ApiClient>(() {
      final options = BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 120),
      );

      final dio = Dio(options);
      dio.interceptors.addAll([
        AuthInterceptor(),
        LogarteDioInterceptor(sl<Logarte>()),
      ]);

      if (kDebugMode) {
        dio.interceptors.add(LoggingInterceptor());
      }

      return DioApiClient(dio);
    });
  }
}
