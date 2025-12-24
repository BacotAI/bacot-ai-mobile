import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_interview_ai/app/app.dart';
import 'package:smart_interview_ai/core/config/flavors.dart';
import 'package:smart_interview_ai/core/di/injection.dart';
import 'package:smart_interview_ai/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();

  final isLoggedIn = true;
  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );
  runApp(App(isLoggedIn: isLoggedIn));
}
