import 'package:smart_interview_ai/features/auth/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> loginWithGoogle();
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<UserModel?> getCurrentUser();
}
