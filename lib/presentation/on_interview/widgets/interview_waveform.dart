import 'dart:math' as math;
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
        children: List.generate(12, (index) {
          // Create some pseudo-random variation based on audioLevel
          // Use a combination of sine waves and the audioLevel to create a dynamic effect
          final phase = index * 0.5;
          final heightFactor =
              (math.sin(phase + audioLevel * math.pi * 2) * 0.3 + 0.7) *
              audioLevel;
          final barHeight = 4.0 + (heightFactor * 24.0);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOutCubic,
            width: 3,
            height: barHeight,
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  const Color(0xFF00C2FF).withValues(alpha: 0.7),
                  const Color(0xFF00C2FF),
                ],
              ),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00C2FF).withValues(alpha: 0.3),
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
