import 'package:flutter/material.dart';

class IceBreakingTransitionOverlay extends StatelessWidget {
  final AnimationController exitController;

  const IceBreakingTransitionOverlay({super.key, required this.exitController});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: exitController,
      child: Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_clock, color: Colors.white54, size: 48),
              SizedBox(height: 16),
              Text(
                "Video sedang dihapus...\nPenyimpanan Anda terjaga.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
