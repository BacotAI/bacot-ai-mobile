import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/app/router/app_router.dart';
import 'package:smart_interview_ai/core/config/app_theme.dart';

class App extends StatefulWidget {
  final bool isLoggedIn;

  const App({super.key, required this.isLoggedIn});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter _appRouter;
  late final Logarte logarte;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
    logarte = sl<Logarte>();

    logarte.attach(context: context, visible: false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Interview AI',
      theme: AppTheme.light,
      routerConfig: _appRouter.config(
        navigatorObservers: () => [LogarteNavigatorObserver(logarte)],
      ),
    );
  }
}
