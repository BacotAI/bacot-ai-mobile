import 'package:flutter/material.dart';

class InterviewWaveform extends StatelessWidget {
  final double audioLevel;

  const InterviewWaveform({super.key, required this.audioLevel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(15, (index) {
          final sensitivity = 2.0;

          final wave = (audioLevel * sensitivity).clamp(0.0, 1.0);
          final staggeredWave =
              (wave * (0.8 + 0.4 * (index % 3 == 0 ? 1 : 0.5))).clamp(0.0, 1.0);
          final barHeight = 4.0 + (staggeredWave * 28.0);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOutCirc,
            width: 3,
            height: barHeight,
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  const Color(0xFF00C2FF).withValues(alpha: 0.6),
                  const Color(0xFF00C2FF),
                ],
              ),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                if (audioLevel > 0.1)
                  BoxShadow(
                    color: const Color(0xFF00C2FF).withValues(alpha: 0.2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
