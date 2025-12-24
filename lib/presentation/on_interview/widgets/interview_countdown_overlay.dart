import 'package:flutter/material.dart';

class InterviewCountdownOverlay extends StatelessWidget {
  final int count;

  const InterviewCountdownOverlay({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "$count",
        style: const TextStyle(
          fontSize: 120,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          shadows: [Shadow(blurRadius: 40, color: Colors.black)],
        ),
      ),
    );
  }
}
