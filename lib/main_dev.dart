import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_interview_ai/app/app.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smart_interview_ai/firebase_options.dart';
import 'package:smart_interview_ai/core/config/flavors.dart';
import 'dart:async';

FutureOr<void> main() async {
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await DI.init();

  final prefs = await SharedPreferences.getInstance();
  final googleSignIn = GoogleSignIn();

  final authRepository = AuthRepositoryImpl(googleSignIn, prefs);
  DI.authRepository = authRepository;

  F.appFlavor = Flavor.dev;
  final isLoggedIn = true;

  runApp(App(isLoggedIn: isLoggedIn));
}
