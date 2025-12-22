import 'package:flutter/material.dart';

class MissionHelpBottomSheet extends StatelessWidget {
  const MissionHelpBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const MissionHelpBottomSheet(),
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
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF0EA5E9),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Mission Guide',
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
            icon: Icons.timer_outlined,
            title: 'Prepare Fast',
            description:
                'Review your questions before the timer starts. Use this time to outline your thoughts.',
          ),
          const SizedBox(height: 24),
          _buildHelpItem(
            icon: Icons.star_border_rounded,
            title: 'STAR Method',
            description:
                'Structure your answers using Situation, Task, Action, and Result for better clarity.',
          ),
          const SizedBox(height: 24),
          _buildHelpItem(
            icon: Icons.psychology_alt_rounded,
            title: 'HR Insights',
            description:
                'Tap "HR Insight" to understand what recruiters are looking for in each specific question.',
          ),
          const SizedBox(height: 24),
          _buildHelpItem(
            icon: Icons.bolt_rounded,
            title: 'Boost Answer',
            description:
                'Use "Boost Answer" to see AI-generated suggestions on how to improve your response.',
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
