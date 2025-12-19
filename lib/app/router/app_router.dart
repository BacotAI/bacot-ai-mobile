import 'package:auto_route/auto_route.dart';
import 'package:smart_interview_ai/app/router/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: AudioInputRoute.page),
    AutoRoute(page: VideoInputRoute.page),
    AutoRoute(page: SmartCameraRoute.page),
    AutoRoute(page: PreInterviewRoute.page),
    AutoRoute(page: IceBreakingRoute.page),
    AutoRoute(page: OnInterviewRoute.page),
  ];
}
