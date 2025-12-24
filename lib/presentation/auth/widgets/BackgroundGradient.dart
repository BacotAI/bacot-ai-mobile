import 'package:flutter/widgets.dart';
import 'package:smart_interview_ai/presentation/auth/widgets/BottomGlow.dart';
import 'package:smart_interview_ai/presentation/auth/widgets/TopGlow.dart';

class Backgroundgradient extends StatelessWidget {
  const Backgroundgradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEDE9FE), Color(0xFFFFFFFF), Color(0xFFDFF3FF)],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: Stack(children: const [Topglow(), Bottomglow()]),
    );
  }
}
