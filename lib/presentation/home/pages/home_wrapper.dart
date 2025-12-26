import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_interview_ai/application/auth/auth_bloc.dart';
import 'package:smart_interview_ai/core/di/injection.dart';

@RoutePage()
class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>()..add(AuthCheckRequested()),
      child: Builder(
        builder: (context) {
          return const AutoRouter();
        },
      ),
    );
  }
}
