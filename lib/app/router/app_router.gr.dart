// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:smart_interview_ai/features/audio_input/presentation/pages/audio_input_page.dart'
    as _i1;
import 'package:smart_interview_ai/features/auth/presentation/pages/login_page.dart'
    as _i3;
import 'package:smart_interview_ai/features/home/presentation/pages/home_page.dart'
    as _i2;
import 'package:smart_interview_ai/features/smart_camera/presentation/pages/smart_camera_page.dart'
    as _i4;
import 'package:smart_interview_ai/features/video_input/presentation/pages/video_input_page.dart'
    as _i5;

/// generated route for
/// [_i1.AudioInputPage]
class AudioInputRoute extends _i6.PageRouteInfo<void> {
  const AudioInputRoute({List<_i6.PageRouteInfo>? children})
    : super(AudioInputRoute.name, initialChildren: children);

  static const String name = 'AudioInputRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.AudioInputPage();
    },
  );
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute({List<_i6.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.LoginPage]
class LoginRoute extends _i6.PageRouteInfo<void> {
  const LoginRoute({List<_i6.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.LoginPage();
    },
  );
}

/// generated route for
/// [_i4.SmartCameraPage]
class SmartCameraRoute extends _i6.PageRouteInfo<void> {
  const SmartCameraRoute({List<_i6.PageRouteInfo>? children})
    : super(SmartCameraRoute.name, initialChildren: children);

  static const String name = 'SmartCameraRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.SmartCameraPage();
    },
  );
}

/// generated route for
/// [_i5.VideoInputPage]
class VideoInputRoute extends _i6.PageRouteInfo<void> {
  const VideoInputRoute({List<_i6.PageRouteInfo>? children})
    : super(VideoInputRoute.name, initialChildren: children);

  static const String name = 'VideoInputRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.VideoInputPage();
    },
  );
}
