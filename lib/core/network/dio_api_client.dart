import 'package:dio/dio.dart';
import 'package:smart_interview_ai/core/network/api_client.dart';
import 'package:smart_interview_ai/core/network/errors.dart';

class DioApiClient implements ApiClient {
  final Dio _dio;
  DioApiClient(this._dio);

  @override
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    try {
      return await _dio.get<T>(path, queryParameters: query, options: Options(headers: headers));
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<Response<T>> post<T>(String path, {Object? data, Map<String, dynamic>? headers}) async {
    try {
      return await _dio.post<T>(path, data: data, options: Options(headers: headers));
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<Response<T>> put<T>(String path, {Object? data, Map<String, dynamic>? headers}) async {
    try {
      return await _dio.put<T>(path, data: data, options: Options(headers: headers));
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<Response<T>> patch<T>(String path, {Object? data, Map<String, dynamic>? headers}) async {
    try {
      return await _dio.patch<T>(path, data: data, options: Options(headers: headers));
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<Response<T>> delete<T>(String path, {Object? data, Map<String, dynamic>? headers}) async {
    try {
      return await _dio.delete<T>(path, data: data, options: Options(headers: headers));
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  NetworkException _mapException(DioException e) {
    final status = e.response?.statusCode;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('Request timed out');
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
        return NoConnectionException('Network connection error');
      case DioExceptionType.badResponse:
        if (status == 400) return BadRequestException('Bad request');
        if (status == 401) return UnauthorizedException('Unauthorized');
        if (status == 403) return ForbiddenException('Forbidden');
        if (status == 404) return NotFoundException('Not found');
        return ServerException('Server error', statusCode: status);
      case DioExceptionType.cancel:
        return UnknownNetworkException('Request cancelled', statusCode: status);
      case DioExceptionType.unknown:
        return UnknownNetworkException(e.message ?? 'Unknown network error', statusCode: status);
    }
  }
}
