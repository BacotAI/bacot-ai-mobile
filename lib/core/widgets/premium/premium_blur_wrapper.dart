import 'dart:ui';
import 'package:flutter/material.dart';

class PremiumBlurWrapper extends StatelessWidget {
  final Widget child;
  final bool isPremium;
  final String message;

  const PremiumBlurWrapper({
    super.key,
    required this.child,
    required this.isPremium,
    this.message = 'Premium Feature — Upgrade to unlock HR Insights',
  });

  @override
  Widget build(BuildContext context) {
    if (isPremium) return child;

    return Stack(
      children: [
        // Content with Blur
        AbsorbPointer(
          absorbing: true,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: child,
          ),
        ),
        // Overlay Content
        Positioned.fill(
          child: Container(
            color: Colors.white.withAlpha(20),
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    color: Color(0xFF0F172A),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () {
                    // TODO: Navigate to subscription page
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withAlpha(200),
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: const Text(
                    'Upgrade Now',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
