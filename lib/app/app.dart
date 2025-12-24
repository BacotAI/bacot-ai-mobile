import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:smart_interview_ai/core/di/injection.dart';
import 'package:smart_interview_ai/app/router/app_router.dart';
import 'package:smart_interview_ai/core/config/app_theme.dart';

class App extends StatefulWidget {
  final bool isLoggedIn;

  const App({super.key, required this.isLoggedIn});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final Logarte logarte;

  @override
  void initState() {
    super.initState();
    logarte = sl<Logarte>();

    logarte.attach(context: context, visible: false);
  }

  @override
  Widget build(BuildContext context) {
    final router = sl<AppRouter>();
    return Container(
      color: const Color(0xFFF8FAFC),
      child: MaterialApp.router(
        title: 'Smart Interview AI',
        color: const Color(0xFFF8FAFC),
        theme: AppTheme.light,
        routerConfig: router.config(
          navigatorObservers: () => [LogarteNavigatorObserver(logarte)],
        ),
      ),
    );
  }
}
