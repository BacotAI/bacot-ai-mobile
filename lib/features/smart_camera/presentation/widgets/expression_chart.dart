import 'package:flutter/material.dart';
import 'package:smart_interview_ai/features/smart_camera/models/expression_data.dart';

class ExpressionChart extends StatelessWidget {
  final ExpressionData data;

  const ExpressionChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(128),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBar("Senyum", data.smile),
          const SizedBox(width: 8),
          _buildVerticalDivider(),
          const SizedBox(width: 8),
          _buildBar("Serius", data.serious),
          const SizedBox(width: 8),
          _buildVerticalDivider(),
          const SizedBox(width: 8),
          _buildBar("Interest", data.interest),
          const SizedBox(width: 8),
          _buildVerticalDivider(),
          const SizedBox(width: 8),
          _buildBar("Expressiveness", data.expressiveness),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(width: 1, height: 60, color: Colors.white.withAlpha(128));
  }

  Widget _buildBar(String label, double value) {
    // Max height for the bar area
    const double barAreaHeight = 60;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bar area
        SizedBox(
          height: barAreaHeight,
          width: 20,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Background line (optional, maybe just the bar)

              // Animated Bar
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: value),
                duration: const Duration(milliseconds: 300),
                builder: (context, animatedValue, child) {
                  final height = (animatedValue / 100) * barAreaHeight;
                  return Container(
                    height: height,
                    width: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD54F), // Yellow color from image
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Value Text
        Text(
          value.toInt().toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        // Label Text
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }
}
