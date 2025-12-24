import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_interview_ai/app/app.dart';
import 'package:smart_interview_ai/core/di/injection.dart';
import 'package:smart_interview_ai/firebase_options.dart';
import 'package:smart_interview_ai/core/config/flavors.dart';
import 'dart:async';

FutureOr<void> main() async {
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();

  // await dotenv.load(fileName: ".env.uat");

  F.appFlavor = Flavor.uat;
  final isLoggedIn = true;

  runApp(App(isLoggedIn: isLoggedIn));
}
