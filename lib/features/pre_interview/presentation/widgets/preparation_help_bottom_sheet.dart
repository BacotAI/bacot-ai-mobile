import 'package:flutter/material.dart';

class PreparationHelpBottomSheet extends StatelessWidget {
  const PreparationHelpBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const PreparationHelpBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.help_outline_rounded,
                  color: Color(0xFF0EA5E9),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Preparation Guide',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildHelpItem(
            icon: Icons.info_outline_rounded,
            title: 'What is this page?',
            description:
                'This is your interview briefing. It outlines the structure of your upcoming practice session.',
          ),
          const SizedBox(height: 24),
          _buildHelpItem(
            icon: Icons.bolt_rounded,
            title: 'Warm-up & Exercises',
            description:
                'Start with the Icebreaker to relax. Questions are categorized by type (Behavioral, Technical) and difficulty.',
          ),
          const SizedBox(height: 24),
          _buildHelpItem(
            icon: Icons.lock_open_rounded,
            title: 'Unlock Content',
            description:
                'Complete active questions to unlock subsequent ones. Focus on your current active challenge.',
          ),
          const SizedBox(height: 24),
          _buildHelpItem(
            icon: Icons.lightbulb_outline_rounded,
            title: 'Pro Tips',
            description:
                'Look for "View Tips" and "Method Hints" to get AI-powered guidance on how to answer effectively.',
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF64748B)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
