import 'package:get_it/get_it.dart';
import 'package:smart_interview_ai/app/router/app_router.dart';
import 'package:smart_interview_ai/app/router/auth_guard.dart';

abstract class RouterModule {
  static void init(GetIt sl) {
    sl.registerLazySingleton<AuthGuard>(() => AuthGuard());
    sl.registerLazySingleton<AppRouter>(() => AppRouter(sl<AuthGuard>()));
  }
}
