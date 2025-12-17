import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_interview_ai/app/app.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/features/auth/repositories/auth_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await DI.init();

  final prefs = await SharedPreferences.getInstance();
  final googleSignIn = GoogleSignIn();

  final authRepository = AuthRepositoryImpl(googleSignIn, prefs);
  DI.authRepository = authRepository;

  //TODO: replace if ready
  // final isLoggedIn = await authRepository.isLoggedIn();
  final isLoggedIn =
      true; // Still using hardcoded true for now as per original code

  runApp(App(isLoggedIn: isLoggedIn));
}
