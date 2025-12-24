import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/application/auth/auth_bloc.dart';
import 'package:smart_interview_ai/presentation/home/widgets/home.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Stack(children: [Home()]),
      ),
    );
  }
}
