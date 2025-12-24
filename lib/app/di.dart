import 'package:get_it/get_it.dart';
import 'package:smart_interview_ai/app/router/app_router.dart';
import 'package:smart_interview_ai/app/router/auth_guard.dart';
import 'package:smart_interview_ai/domain/auth/auth_repository.dart';

final sl = GetIt.instance;

class DI {
  static AuthRepository get authRepository => sl<AuthRepository>();
  static AppRouter get appRouter => sl<AppRouter>();
  static AuthGuard get authGuard => sl<AuthGuard>();
}
