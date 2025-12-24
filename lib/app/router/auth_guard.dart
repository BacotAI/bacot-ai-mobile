import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/app/router/app_router.gr.dart';

class AuthGuard implements AutoRouteGuard {
  @override
  FutureOr<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final isLoggedIn = await DI.authRepository.isLoggedIn();

    if (!isLoggedIn) {
      resolver.next(true);
    } else {
      router.replace(const LoginRoute());
    }
  }
}
