// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;
import 'package:smart_interview_ai/domain/pre_interview/entities/question_entity.dart'
    as _i14;
import 'package:smart_interview_ai/presentation/audio_input/pages/audio_input_page.dart'
    as _i1;
import 'package:smart_interview_ai/presentation/auth/pages/login_page.dart'
    as _i5;
import 'package:smart_interview_ai/presentation/home/pages/home_page.dart'
    as _i2;
import 'package:smart_interview_ai/presentation/navbar/navbar_wrapper.dart'
    as _i7;
import 'package:smart_interview_ai/presentation/on_interview/pages/on_interview_page.dart'
    as _i8;
import 'package:smart_interview_ai/presentation/pre_interview/pages/ice_breaking_page.dart'
    as _i3;
import 'package:smart_interview_ai/presentation/pre_interview/pages/interview_briefing_page.dart'
    as _i4;
import 'package:smart_interview_ai/presentation/pre_interview/pages/mission_briefing_page.dart'
    as _i6;
import 'package:smart_interview_ai/presentation/pre_interview/pages/pre_interview_page.dart'
    as _i9;
import 'package:smart_interview_ai/presentation/profile/pages/profile_page.dart'
    as _i10;
import 'package:smart_interview_ai/presentation/smart_camera/pages/smart_camera_page.dart'
    as _i11;

/// generated route for
/// [_i1.AudioInputPage]
class AudioInputRoute extends _i12.PageRouteInfo<void> {
  const AudioInputRoute({List<_i12.PageRouteInfo>? children})
    : super(AudioInputRoute.name, initialChildren: children);

  static const String name = 'AudioInputRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i1.AudioInputPage();
    },
  );
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i12.PageRouteInfo<void> {
  const HomeRoute({List<_i12.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.IceBreakingPage]
class IceBreakingRoute extends _i12.PageRouteInfo<IceBreakingRouteArgs> {
  IceBreakingRoute({
    _i13.Key? key,
    required _i14.QuestionEntity question,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         IceBreakingRoute.name,
         args: IceBreakingRouteArgs(key: key, question: question),
         initialChildren: children,
       );

  static const String name = 'IceBreakingRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<IceBreakingRouteArgs>();
      return _i3.IceBreakingPage(key: args.key, question: args.question);
    },
  );
}

class IceBreakingRouteArgs {
  const IceBreakingRouteArgs({this.key, required this.question});

  final _i13.Key? key;

  final _i14.QuestionEntity question;

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
/// [_i4.InterviewBriefingPage]
class InterviewBriefingRoute extends _i12.PageRouteInfo<void> {
  const InterviewBriefingRoute({List<_i12.PageRouteInfo>? children})
    : super(InterviewBriefingRoute.name, initialChildren: children);

  static const String name = 'InterviewBriefingRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i4.InterviewBriefingPage();
    },
  );
}

/// generated route for
/// [_i5.LoginPage]
class LoginRoute extends _i12.PageRouteInfo<void> {
  const LoginRoute({List<_i12.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i5.LoginPage();
    },
  );
}

/// generated route for
/// [_i6.MissionBriefingPage]
class MissionBriefingRoute extends _i12.PageRouteInfo<void> {
  const MissionBriefingRoute({List<_i12.PageRouteInfo>? children})
    : super(MissionBriefingRoute.name, initialChildren: children);

  static const String name = 'MissionBriefingRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i6.MissionBriefingPage();
    },
  );
}

/// generated route for
/// [_i7.NavbarWrapperPage]
class NavbarWrapperRoute extends _i12.PageRouteInfo<NavbarWrapperRouteArgs> {
  NavbarWrapperRoute({
    _i13.Key? key,
    _i13.GlobalKey<_i13.State<_i13.StatefulWidget>>? homeKey,
    _i13.GlobalKey<_i13.State<_i13.StatefulWidget>>? plusKey,
    _i13.GlobalKey<_i13.State<_i13.StatefulWidget>>? profileKey,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         NavbarWrapperRoute.name,
         args: NavbarWrapperRouteArgs(
           key: key,
           homeKey: homeKey,
           plusKey: plusKey,
           profileKey: profileKey,
         ),
         initialChildren: children,
       );

  static const String name = 'NavbarWrapperRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NavbarWrapperRouteArgs>(
        orElse: () => const NavbarWrapperRouteArgs(),
      );
      return _i7.NavbarWrapperPage(
        key: args.key,
        homeKey: args.homeKey,
        plusKey: args.plusKey,
        profileKey: args.profileKey,
      );
    },
  );
}

class NavbarWrapperRouteArgs {
  const NavbarWrapperRouteArgs({
    this.key,
    this.homeKey,
    this.plusKey,
    this.profileKey,
  });

  final _i13.Key? key;

  final _i13.GlobalKey<_i13.State<_i13.StatefulWidget>>? homeKey;

  final _i13.GlobalKey<_i13.State<_i13.StatefulWidget>>? plusKey;

  final _i13.GlobalKey<_i13.State<_i13.StatefulWidget>>? profileKey;

  @override
  String toString() {
    return 'NavbarWrapperRouteArgs{key: $key, homeKey: $homeKey, plusKey: $plusKey, profileKey: $profileKey}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NavbarWrapperRouteArgs) return false;
    return key == other.key &&
        homeKey == other.homeKey &&
        plusKey == other.plusKey &&
        profileKey == other.profileKey;
  }

  @override
  int get hashCode =>
      key.hashCode ^ homeKey.hashCode ^ plusKey.hashCode ^ profileKey.hashCode;
}

/// generated route for
/// [_i8.OnInterviewPage]
class OnInterviewRoute extends _i12.PageRouteInfo<OnInterviewRouteArgs> {
  OnInterviewRoute({
    _i13.Key? key,
    required _i14.QuestionEntity question,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         OnInterviewRoute.name,
         args: OnInterviewRouteArgs(key: key, question: question),
         initialChildren: children,
       );

  static const String name = 'OnInterviewRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OnInterviewRouteArgs>();
      return _i8.OnInterviewPage(key: args.key, question: args.question);
    },
  );
}

class OnInterviewRouteArgs {
  const OnInterviewRouteArgs({this.key, required this.question});

  final _i13.Key? key;

  final _i14.QuestionEntity question;

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
/// [_i9.PreInterviewPage]
class PreInterviewRoute extends _i12.PageRouteInfo<void> {
  const PreInterviewRoute({List<_i12.PageRouteInfo>? children})
    : super(PreInterviewRoute.name, initialChildren: children);

  static const String name = 'PreInterviewRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i9.PreInterviewPage();
    },
  );
}

/// generated route for
/// [_i10.ProfilePage]
class ProfileRoute extends _i12.PageRouteInfo<void> {
  const ProfileRoute({List<_i12.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i10.ProfilePage();
    },
  );
}

/// generated route for
/// [_i11.SmartCameraPage]
class SmartCameraRoute extends _i12.PageRouteInfo<void> {
  const SmartCameraRoute({List<_i12.PageRouteInfo>? children})
    : super(SmartCameraRoute.name, initialChildren: children);

  static const String name = 'SmartCameraRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i11.SmartCameraPage();
    },
  );
}
