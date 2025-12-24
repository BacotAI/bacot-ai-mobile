import 'package:flutter/material.dart';

class InterviewControls extends StatelessWidget {
  final bool canGoNext;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const InterviewControls({
    super.key,
    required this.canGoNext,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: [
          // Skip Button
          _ControlButton(
            onPressed: onSkip,
            icon: Icons.fast_forward_rounded,
            label: "LEWATI",
            color: Colors.white,
            textColor: Colors.grey,
          ),
          const SizedBox(width: 16),
          // Next Button (Finish Answer)
          Expanded(
            child: _MainActionButton(
              onPressed: canGoNext ? onNext : null,
              label: "Selesai Menjawab",
              subLabel: "SIAP LANJUT?",
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;

  const _ControlButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: textColor, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final String subLabel;

  const _MainActionButton({
    required this.onPressed,
    required this.label,
    required this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: isEnabled
              ? const Color(0xFF0F172A)
              : Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(24),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  subLabel,
                  style: TextStyle(
                    color: isEnabled ? Colors.white70 : Colors.black38,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: isEnabled ? Colors.white : Colors.black45,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isEnabled ? Colors.white24 : Colors.black12,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: isEnabled ? Colors.white : Colors.black26,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
