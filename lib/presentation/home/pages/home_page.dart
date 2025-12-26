import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(children: [Home()]),
    );
  }
}
