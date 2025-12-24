import 'package:smart_interview_ai/app/router/app_router.dart';
import 'package:smart_interview_ai/app/router/auth_guard.dart';
import 'package:smart_interview_ai/core/di/injection.dart' as injection;
import 'package:smart_interview_ai/features/auth/domain/repositories/auth_repository.dart';

final sl = injection.sl;

class DI {
  static AuthRepository get authRepository => sl<AuthRepository>();
  static AppRouter get appRouter => sl<AppRouter>();
  static AuthGuard get authGuard => sl<AuthGuard>();

  static Future<void> init() async {
    await injection.Injection.init();
  }

  static set authRepository(AuthRepository repository) {
    if (sl.isRegistered<AuthRepository>()) {
      sl.unregister<AuthRepository>();
    }
    sl.registerSingleton<AuthRepository>(repository);
  }
}
