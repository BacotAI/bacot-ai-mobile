import 'package:smart_interview_ai/app/router/app_router.dart';
import 'package:smart_interview_ai/app/router/auth_guard.dart';
import 'package:smart_interview_ai/core/di/injection.dart' as injection;
import 'package:smart_interview_ai/domain/auth/auth_repository.dart';

final sl = injection.sl;

class DI {
  static AuthRepository get authRepository => sl<AuthRepository>();
  static AppRouter get appRouter => sl<AppRouter>();
  static AuthGuard get authGuard => sl<AuthGuard>();
}
