import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_interview_ai/features/auth/models/user_model.dart';
import 'package:smart_interview_ai/features/auth/domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignIn _googleSignIn;
  final SharedPreferences _prefs;

  static const String _userKey = 'auth_user_data';

  AuthRepositoryImpl(this._googleSignIn, this._prefs);

  @override
  Future<UserModel?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      print('User signed in: ${googleUser.toString()}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // In a real app, you might send this token to your backend
      // for validation and to get a session JWT.
      // For this task, we'll create a UserModel directly.

      final user = UserModel(
        id: googleUser.id,
        email: googleUser.email,
        displayName: googleUser.displayName ?? '',
        photoUrl: googleUser.photoUrl,
        token:
            googleAuth.accessToken ??
            googleAuth.idToken, // Using accessToken or idToken
      );

      print('User created: ${user.toString()}');

      await _saveUser(user);
      return user;
    } catch (e) {
      // Handle error gracefully
      print('Google Sign-In Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _prefs.remove(_userKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    return _prefs.containsKey(_userKey);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> _saveUser(UserModel user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
}
