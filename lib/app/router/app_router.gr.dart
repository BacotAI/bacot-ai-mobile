// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;
import 'package:smart_interview_ai/features/audio_input/presentation/pages/audio_input_page.dart'
    as _i1;
import 'package:smart_interview_ai/features/auth/presentation/pages/login_page.dart'
    as _i4;
import 'package:smart_interview_ai/features/home/presentation/pages/home_page.dart'
    as _i2;
import 'package:smart_interview_ai/features/on_interview/presentation/pages/on_interview_page.dart'
    as _i5;
import 'package:smart_interview_ai/features/pre_interview/domain/entities/question_entity.dart'
    as _i10;
import 'package:smart_interview_ai/features/pre_interview/presentation/pages/ice_breaking_page.dart'
    as _i3;
import 'package:smart_interview_ai/features/pre_interview/presentation/pages/pre_interview_page.dart'
    as _i6;
import 'package:smart_interview_ai/features/smart_camera/presentation/pages/smart_camera_page.dart'
    as _i7;

/// generated route for
/// [_i1.AudioInputPage]
class AudioInputRoute extends _i8.PageRouteInfo<void> {
  const AudioInputRoute({List<_i8.PageRouteInfo>? children})
    : super(AudioInputRoute.name, initialChildren: children);

  static const String name = 'AudioInputRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i1.AudioInputPage();
    },
  );
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i8.PageRouteInfo<void> {
  const HomeRoute({List<_i8.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.IceBreakingPage]
class IceBreakingRoute extends _i8.PageRouteInfo<IceBreakingRouteArgs> {
  IceBreakingRoute({
    _i9.Key? key,
    required _i10.QuestionEntity question,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         IceBreakingRoute.name,
         args: IceBreakingRouteArgs(key: key, question: question),
         initialChildren: children,
       );

  static const String name = 'IceBreakingRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<IceBreakingRouteArgs>();
      return _i3.IceBreakingPage(key: args.key, question: args.question);
    },
  );
}

class IceBreakingRouteArgs {
  const IceBreakingRouteArgs({this.key, required this.question});

  final _i9.Key? key;

  final _i10.QuestionEntity question;

  @override
  String toString() {
    return 'IceBreakingRouteArgs{key: $key, question: $question}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! IceBreakingRouteArgs) return false;
    return key == other.key && question == other.question;
  }

  @override
  int get hashCode => key.hashCode ^ question.hashCode;
}

/// generated route for
/// [_i4.LoginPage]
class LoginRoute extends _i8.PageRouteInfo<void> {
  const LoginRoute({List<_i8.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i4.LoginPage();
    },
  );
}

/// generated route for
/// [_i5.OnInterviewPage]
class OnInterviewRoute extends _i8.PageRouteInfo<OnInterviewRouteArgs> {
  OnInterviewRoute({
    _i9.Key? key,
    required _i10.QuestionEntity question,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         OnInterviewRoute.name,
         args: OnInterviewRouteArgs(key: key, question: question),
         initialChildren: children,
       );

  static const String name = 'OnInterviewRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OnInterviewRouteArgs>();
      return _i5.OnInterviewPage(key: args.key, question: args.question);
    },
  );
}

class OnInterviewRouteArgs {
  const OnInterviewRouteArgs({this.key, required this.question});

  final _i9.Key? key;

  final _i10.QuestionEntity question;

  @override
  String toString() {
    return 'OnInterviewRouteArgs{key: $key, question: $question}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OnInterviewRouteArgs) return false;
    return key == other.key && question == other.question;
  }

  @override
  int get hashCode => key.hashCode ^ question.hashCode;
}

/// generated route for
/// [_i6.PreInterviewPage]
class PreInterviewRoute extends _i8.PageRouteInfo<void> {
  const PreInterviewRoute({List<_i8.PageRouteInfo>? children})
    : super(PreInterviewRoute.name, initialChildren: children);

  static const String name = 'PreInterviewRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.PreInterviewPage();
    },
  );
}

/// generated route for
/// [_i7.SmartCameraPage]
class SmartCameraRoute extends _i8.PageRouteInfo<void> {
  const SmartCameraRoute({List<_i8.PageRouteInfo>? children})
    : super(SmartCameraRoute.name, initialChildren: children);

  static const String name = 'SmartCameraRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.SmartCameraPage();
    },
  );
}
