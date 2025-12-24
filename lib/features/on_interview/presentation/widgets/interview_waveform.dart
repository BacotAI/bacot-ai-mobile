import 'dart:math' as math;
import 'package:flutter/material.dart';

class InterviewWaveform extends StatelessWidget {
  final double audioLevel;

  const InterviewWaveform({super.key, required this.audioLevel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(8, (index) {
        // Create some pseudo-random variation based on audioLevel
        final heightFactor =
            math.sin((index + 1) * audioLevel * math.pi) * 0.5 + 0.5;
        final barHeight = 4.0 + (heightFactor * 16.0);

        return Container(
          width: 4,
          height: barHeight,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF00C2FF),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
