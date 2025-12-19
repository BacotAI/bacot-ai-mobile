import 'package:flutter/material.dart';

class IceBreakingTransitionOverlay extends StatelessWidget {
  final AnimationController exitController;

  const IceBreakingTransitionOverlay({super.key, required this.exitController});

  @override
  Widget build(BuildContext context) {
    // "Shredder" Effect:
    // Scale down vertically to 0 while maintaining width? Or fade to black with noise?
    // Let's do a Fade + Zoom Out + "Digital Noise" feel (black overlay).
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
