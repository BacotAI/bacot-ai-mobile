import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _redactSensitive(options.headers);

    final msg = StringBuffer();
    msg.writeln('🚀 Request: ${options.method} ${options.uri}');
    if (options.headers.isNotEmpty) {
      msg.writeln('Headers: ${_prettyJson(options.headers)}');
    }
    if (options.data != null) {
      msg.writeln('Body: ${_prettyJson(options.data)}');
    }
    _log(msg.toString(), _AnsiColor.cyan);

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final msg = StringBuffer();
    msg.writeln(
      '✅ Response: ${response.statusCode} ${response.requestOptions.uri}',
    );
    if (response.data != null) {
      msg.writeln('Body: ${_prettyJson(response.data)}');
    }
    _log(msg.toString(), _AnsiColor.green);

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final msg = StringBuffer();
    msg.writeln(
      '❌ Error: ${err.response?.statusCode} ${err.requestOptions.uri}',
    );
    msg.writeln('Message: ${err.message}');
    if (err.response?.data != null) {
      msg.writeln('Error Data: ${_prettyJson(err.response?.data)}');
    }
    _log(msg.toString(), _AnsiColor.red);

    handler.next(err);
  }

  void _redactSensitive(Map<String, dynamic> headers) {
    final auth = headers['Authorization'] ?? headers['authorization'];
    if (auth is String && auth.isNotEmpty) {
      headers['Authorization'] = 'Bearer ***';
    }
  }

  void _log(String message, String color) {
    if (kDebugMode) {
      debugPrint('$color$message${_AnsiColor.reset}');
    }
  }

  String _prettyJson(dynamic data) {
    try {
      if (data is FormData) {
        return 'FormData(...)';
      }
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (e) {
      return data.toString();
    }
  }
}

class _AnsiColor {
  static const String reset = '\x1B[0m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String cyan = '\x1B[36m';
}
