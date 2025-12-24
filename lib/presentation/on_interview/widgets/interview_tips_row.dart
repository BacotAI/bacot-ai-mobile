import 'package:flutter/material.dart';

class InterviewTipsRow extends StatelessWidget {
  const InterviewTipsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withAlpha(26)),
      ),
      child: Row(
        children: const [
          Icon(Icons.lightbulb_outline, color: Color(0xFF00C2FF), size: 18),
          SizedBox(width: 8),
          Text(
            "Tips: Gunakan metode STAR for answering.",
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
