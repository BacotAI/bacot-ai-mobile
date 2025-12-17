import 'package:flutter/material.dart';

class AudioControlButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color color;
  final double size;

  const AudioControlButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: color, size: size * 0.5),
      ),
    );
  }
}
