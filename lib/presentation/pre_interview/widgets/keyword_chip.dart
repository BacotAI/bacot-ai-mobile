import 'package:flutter/material.dart';

class KeywordChip extends StatelessWidget {
  final String label;

  const KeywordChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // Very light blue
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBFDBFE)), // Light blue border
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF1D4ED8), // Blue-700
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
