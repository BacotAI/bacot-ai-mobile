import 'package:auto_route/auto_route.dart';
import 'package:smart_interview_ai/app/router/app_router.gr.dart';
import 'package:smart_interview_ai/app/router/auth_guard.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard;
  AppRouter(this.authGuard);

  @override
  List<AutoRoute> get routes => [
    // AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page, initial: true),
    AutoRoute(page: HomeRoute.page, guards: [authGuard]),
    AutoRoute(page: AudioInputRoute.page, guards: [authGuard]),
    AutoRoute(page: SmartCameraRoute.page, guards: [authGuard]),
    AutoRoute(page: PreInterviewRoute.page, guards: [authGuard]),
    AutoRoute(page: IceBreakingRoute.page, guards: [authGuard]),
    AutoRoute(page: OnInterviewRoute.page, guards: [authGuard]),
    AutoRoute(page: InterviewBriefingRoute.page, guards: [authGuard]),
  ];
}
