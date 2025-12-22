import 'package:dio/dio.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/app/router/app_router.gr.dart';

class AuthInterceptor extends Interceptor {
  final Dio _retryDio = Dio();
  bool _isRefresh = false;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await DI.authRepository.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401 ||
        err.requestOptions.path.contains('/auth/refresh')) {
      return handler.next(err);
    }

    if (_isRefresh) {
      await Future.delayed(const Duration(milliseconds: 300));
      return handler.next(err);
    }

    _isRefresh = true;
    final refreshed = await DI.authRepository.refreshToken();
    _isRefresh = false;

    if (!refreshed) {
      await DI.authRepository.logout();
      DI.appRouter.replaceAll([const LoginRoute()]);
      return handler.next(err);
    }

    final newToken = await DI.authRepository.getAccessToken();
    final options = err.requestOptions;

    options.headers['Authorization'] = 'Bearer $newToken';
    final response = await _retryDio.fetch(options);
    handler.resolve(response);
  }
}
