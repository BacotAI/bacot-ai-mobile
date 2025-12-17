import 'package:flutter/material.dart';

class InstructionalOverlayText extends StatelessWidget {
  final String? text;
  final Widget? child;

  const InstructionalOverlayText({super.key, this.text, this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
          ),
        ),
        child:
            child ??
            Text(
              text ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
      ),
    );
  }
}
