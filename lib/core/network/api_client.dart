import 'package:dio/dio.dart';

abstract class ApiClient {
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  });

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  });

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  });

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  });
}
