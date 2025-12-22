import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_interview_ai/features/auth/models/save_user_model.dart';
import 'package:smart_interview_ai/features/auth/models/user_model.dart';
import 'package:smart_interview_ai/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignIn _googleSignIn;
  final SharedPreferences _prefs;

  static const String _userKey = 'auth_user_data';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _savedAccountsKey = 'saved_google_accounts';

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

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Firebase user is null');
      }

      // In a real app, you might send this token to your backend
      // for validation and to get a session JWT.
      // For this task, we'll create a UserModel directly.

      final user = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
        photoUrl: firebaseUser.photoURL,
        token: await firebaseUser.getIdToken(),
      );

      print('User created: ${user.toString()}');

      await _saveUser(user);
      await _saveAccountToList(user);
      return user;
    } catch (e) {
      // Handle error gracefully
      print('Google Sign-In Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    final currentUser = await getCurrentUser();

    await _googleSignIn.signOut();
    await _prefs.remove(_userKey);

    if (currentUser == null) return;
    if (currentUser.email.isEmpty) return;

    final raw = _prefs.getString(_savedAccountsKey);
    if (raw == null) return;

    final List list = jsonDecode(raw);

    list.removeWhere(
      (e) => e['email'] == currentUser.email && currentUser.email.isNotEmpty,
    );

    await _prefs.setString(_savedAccountsKey, jsonEncode(list));
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

  @override
  Future<String?> getAccessToken() async {
    return _prefs.getString(_accessTokenKey);
  }

  @override
  Future<bool> refreshToken() async {
    final refreshToken = _prefs.getString(_refreshTokenKey);
    if (refreshToken == null) return false;

    try {
      // TODO api refresh token
      await Future.delayed(const Duration(seconds: 1));
      final newAccessToken = 'new_access_token_${DateTime.now()}';
      await _prefs.setString(_accessTokenKey, newAccessToken);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }

  @override
  Future<List<SaveUserModel>> getSavedAccounts() async {
    final raw = _prefs.getString(_savedAccountsKey);
    if (raw == null) return [];

    final List list = jsonDecode(raw);
    return list.map((e) => SaveUserModel.fromJson(e)).toList();
  }

  @override
  Future<UserModel?> switchAccount(SaveUserModel selected) async {
    final raw = _prefs.getString(_savedAccountsKey);
    if (raw == null) return null;

    final list = jsonDecode(raw) as List;
    final found = list.firstWhere(
      (e) => e['email'] == selected.email,
      orElse: () => null,
    );

    if (found == null) return null;

    final user = UserModel.fromJson(found);

    await _saveUser(user);
    return user;
  }

  Future<void> _saveAccountToList(UserModel user) async {
    final raw = _prefs.getString(_savedAccountsKey);
    List list = raw != null ? jsonDecode(raw) : [];

    final exists = list.any((e) => e['email'] == user.email);
    if (!exists) {
      final saveUser = SaveUserModel(
        id: user.id,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
      );

      list.add(saveUser.toJson());
      await _prefs.setString(_savedAccountsKey, jsonEncode(list));
    }
  }

  @override
  Future<void> disconnectGoogle() async {
    try {
      final isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        await _googleSignIn.disconnect();
      }
    } catch (e) {
      debugPrint('Google disconnect ignored: $e');
    }
  }

  @override
  Future<UserModel?> continueWithSavedUser() async {
    final user = await getCurrentUser();
    if (user == null) {
      throw Exception('No saved user');
    }

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await firebaseUser.getIdToken(true);
    }

    return user;
  }
}
