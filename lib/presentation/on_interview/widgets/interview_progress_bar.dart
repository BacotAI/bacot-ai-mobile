import 'package:flutter/material.dart';

class InterviewProgressBar extends StatelessWidget {
  final int currentIndex;
  final int totalSteps;

  const InterviewProgressBar({
    super.key,
    required this.currentIndex,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < currentIndex;
        final isCurrent = index == currentIndex;

        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 8),
            decoration: BoxDecoration(
              color: isCompleted || isCurrent
                  ? const Color(0xFF00C2FF) // Vibrant blue from image
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: isCurrent
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: const _AnimatedProgressFill(),
                  )
                : null,
          ),
        );
      }),
    );
  }
}

class _AnimatedProgressFill extends StatefulWidget {
  const _AnimatedProgressFill();

  @override
  State<_AnimatedProgressFill> createState() => _AnimatedProgressFillState();
}

class _AnimatedProgressFillState extends State<_AnimatedProgressFill>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ), // Loop animation or sync with timer?
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // For now, just a steady color, but could be a shimmer or something
    return Container(color: const Color(0xFF00C2FF));
  }
}
