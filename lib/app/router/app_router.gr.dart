// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:collection/collection.dart' as _i16;
import 'package:flutter/material.dart' as _i14;
import 'package:smart_interview_ai/domain/pre_interview/entities/question_entity.dart'
    as _i15;
import 'package:smart_interview_ai/presentation/audio_input/pages/audio_input_page.dart'
    as _i1;
import 'package:smart_interview_ai/presentation/auth/pages/login_page.dart'
    as _i6;
import 'package:smart_interview_ai/presentation/home/pages/home_page.dart'
    as _i2;
import 'package:smart_interview_ai/presentation/home/pages/home_wrapper.dart'
    as _i3;
import 'package:smart_interview_ai/presentation/navbar/navbar_wrapper.dart'
    as _i8;
import 'package:smart_interview_ai/presentation/on_interview/pages/on_interview_page.dart'
    as _i9;
import 'package:smart_interview_ai/presentation/pre_interview/pages/ice_breaking_page.dart'
    as _i4;
import 'package:smart_interview_ai/presentation/pre_interview/pages/interview_briefing_page.dart'
    as _i5;
import 'package:smart_interview_ai/presentation/pre_interview/pages/mission_briefing_page.dart'
    as _i7;
import 'package:smart_interview_ai/presentation/pre_interview/pages/pre_interview_page.dart'
    as _i10;
import 'package:smart_interview_ai/presentation/profile/pages/profile_page.dart'
    as _i11;
import 'package:smart_interview_ai/presentation/smart_camera/pages/smart_camera_page.dart'
    as _i12;

/// generated route for
/// [_i1.AudioInputPage]
class AudioInputRoute extends _i13.PageRouteInfo<void> {
  const AudioInputRoute({List<_i13.PageRouteInfo>? children})
    : super(AudioInputRoute.name, initialChildren: children);

  static const String name = 'AudioInputRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i1.AudioInputPage();
    },
  );
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i13.PageRouteInfo<void> {
  const HomeRoute({List<_i13.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.HomeWrapper]
class HomeWrapper extends _i13.PageRouteInfo<void> {
  const HomeWrapper({List<_i13.PageRouteInfo>? children})
    : super(HomeWrapper.name, initialChildren: children);

  static const String name = 'HomeWrapper';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i3.HomeWrapper();
    },
  );
}

/// generated route for
/// [_i4.IceBreakingPage]
class IceBreakingRoute extends _i13.PageRouteInfo<IceBreakingRouteArgs> {
  IceBreakingRoute({
    _i14.Key? key,
    required _i15.QuestionEntity question,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         IceBreakingRoute.name,
         args: IceBreakingRouteArgs(key: key, question: question),
         initialChildren: children,
       );

  static const String name = 'IceBreakingRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<IceBreakingRouteArgs>();
      return _i4.IceBreakingPage(key: args.key, question: args.question);
    },
  );
}

class IceBreakingRouteArgs {
  const IceBreakingRouteArgs({this.key, required this.question});

  final _i14.Key? key;

  final _i15.QuestionEntity question;

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
/// [_i5.InterviewBriefingPage]
class InterviewBriefingRoute extends _i13.PageRouteInfo<void> {
  const InterviewBriefingRoute({List<_i13.PageRouteInfo>? children})
    : super(InterviewBriefingRoute.name, initialChildren: children);

  static const String name = 'InterviewBriefingRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i5.InterviewBriefingPage();
    },
  );
}

/// generated route for
/// [_i6.LoginPage]
class LoginRoute extends _i13.PageRouteInfo<void> {
  const LoginRoute({List<_i13.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i6.LoginPage();
    },
  );
}

/// generated route for
/// [_i7.MissionBriefingPage]
class MissionBriefingRoute extends _i13.PageRouteInfo<void> {
  const MissionBriefingRoute({List<_i13.PageRouteInfo>? children})
    : super(MissionBriefingRoute.name, initialChildren: children);

  static const String name = 'MissionBriefingRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i7.MissionBriefingPage();
    },
  );
}

/// generated route for
/// [_i8.NavbarWrapperPage]
class NavbarWrapperRoute extends _i13.PageRouteInfo<NavbarWrapperRouteArgs> {
  NavbarWrapperRoute({
    _i14.Key? key,
    _i14.GlobalKey<_i14.State<_i14.StatefulWidget>>? homeKey,
    _i14.GlobalKey<_i14.State<_i14.StatefulWidget>>? plusKey,
    _i14.GlobalKey<_i14.State<_i14.StatefulWidget>>? profileKey,
    List<_i13.PageRouteInfo>? children,
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

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NavbarWrapperRouteArgs>(
        orElse: () => const NavbarWrapperRouteArgs(),
      );
      return _i8.NavbarWrapperPage(
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

  final _i14.Key? key;

  final _i14.GlobalKey<_i14.State<_i14.StatefulWidget>>? homeKey;

  final _i14.GlobalKey<_i14.State<_i14.StatefulWidget>>? plusKey;

  final _i14.GlobalKey<_i14.State<_i14.StatefulWidget>>? profileKey;

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
/// [_i9.OnInterviewPage]
class OnInterviewRoute extends _i13.PageRouteInfo<OnInterviewRouteArgs> {
  OnInterviewRoute({
    _i14.Key? key,
    required List<_i15.QuestionEntity> questions,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         OnInterviewRoute.name,
         args: OnInterviewRouteArgs(key: key, questions: questions),
         initialChildren: children,
       );

  static const String name = 'OnInterviewRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OnInterviewRouteArgs>();
      return _i9.OnInterviewPage(key: args.key, questions: args.questions);
    },
  );
}

class OnInterviewRouteArgs {
  const OnInterviewRouteArgs({this.key, required this.questions});

  final _i14.Key? key;

  final List<_i15.QuestionEntity> questions;

  @override
  String toString() {
    return 'OnInterviewRouteArgs{key: $key, questions: $questions}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OnInterviewRouteArgs) return false;
    return key == other.key &&
        const _i16.ListEquality<_i15.QuestionEntity>().equals(
          questions,
          other.questions,
        );
  }

  @override
  int get hashCode =>
      key.hashCode ^
      const _i16.ListEquality<_i15.QuestionEntity>().hash(questions);
}

/// generated route for
/// [_i10.PreInterviewPage]
class PreInterviewRoute extends _i13.PageRouteInfo<void> {
  const PreInterviewRoute({List<_i13.PageRouteInfo>? children})
    : super(PreInterviewRoute.name, initialChildren: children);

  static const String name = 'PreInterviewRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i10.PreInterviewPage();
    },
  );
}

/// generated route for
/// [_i11.ProfilePage]
class ProfileRoute extends _i13.PageRouteInfo<void> {
  const ProfileRoute({List<_i13.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i11.ProfilePage();
    },
  );
}

/// generated route for
/// [_i12.SmartCameraPage]
class SmartCameraRoute extends _i13.PageRouteInfo<void> {
  const SmartCameraRoute({List<_i13.PageRouteInfo>? children})
    : super(SmartCameraRoute.name, initialChildren: children);

  static const String name = 'SmartCameraRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i12.SmartCameraPage();
    },
  );
}
