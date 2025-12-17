import 'package:flutter/foundation.dart';

class Log {
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _cyan = '\x1B[36m';

  static void error(String msg) {
    if (kDebugMode) {
      print('$_red[ERROR] $msg$_reset');
    }
  }

  static void success(String msg) {
    if (kDebugMode) {
      print('$_green[SUCCESS] $msg$_reset');
    }
  }

  static void warning(String msg) {
    if (kDebugMode) {
      print('$_yellow[WARNING] $msg$_reset');
    }
  }

  static void info(String msg) {
    if (kDebugMode) {
      print('$_cyan[INFO] $msg$_reset');
    }
  }

  static void debug(String msg) {
    if (kDebugMode) {
      print('$_blue[DEBUG] $msg$_reset');
    }
  }
}
