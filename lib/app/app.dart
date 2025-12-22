import 'package:flutter/material.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/core/config/app_theme.dart';

class App extends StatelessWidget {
  final bool isLoggedIn;

  const App({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Interview AI',
      theme: AppTheme.light,
      routerConfig: DI.appRouter.config(),
    );
  }
}
