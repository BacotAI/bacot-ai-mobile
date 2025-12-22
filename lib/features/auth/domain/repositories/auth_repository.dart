import 'package:smart_interview_ai/features/auth/models/save_user_model.dart';
import 'package:smart_interview_ai/features/auth/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> loginWithGoogle();
  Future<UserModel?> switchAccount(SaveUserModel selected);
  Future<List<SaveUserModel>> getSavedAccounts();
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<UserModel?> getCurrentUser();
  Future<String?> getAccessToken();
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<bool> refreshToken();
  Future<void> disconnectGoogle();
  Future<UserModel?> continueWithSavedUser();
}
