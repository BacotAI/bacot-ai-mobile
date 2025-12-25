import 'package:auto_route/auto_route.dart';
import 'package:smart_interview_ai/app/router/app_router.gr.dart';
import 'package:smart_interview_ai/app/router/auth_guard.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard;
  AppRouter(this.authGuard);

  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
    // AutoRoute(page: LoginRoute.page, initial: true),
    // AutoRoute(
    //   path: '/navbar-home-wrapper',
    //   page: NavbarWrapperRoute.page,
    //   guards: [authGuard],
    //   children: [
    //     AutoRoute(page: HomeRoute.page, initial: true),
    //     AutoRoute(page: AudioInputRoute.page),
    //     AutoRoute(page: ProfileRoute.page),
    //   ],
    // ),
    AutoRoute(page: SmartCameraRoute.page, guards: [authGuard]),
    AutoRoute(page: PreInterviewRoute.page, guards: [authGuard]),
    AutoRoute(page: IceBreakingRoute.page, guards: [authGuard]),
    AutoRoute(page: OnInterviewRoute.page, guards: [authGuard]),
    AutoRoute(page: InterviewBriefingRoute.page, guards: [authGuard]),
    AutoRoute(
      page: MissionBriefingRoute.page,
      guards: [authGuard],
      initial: true,
    ),
  ];
}
