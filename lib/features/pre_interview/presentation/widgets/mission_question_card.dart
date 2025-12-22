import 'package:flutter/material.dart';
import 'briefing_tag.dart';

class MissionQuestionCard extends StatelessWidget {
  final String questionNumber;
  final String category;
  final String duration;
  final String question;
  final String focus;
  final Color categoryColor;
  final Color categoryBgColor;
  final bool isActive;

  const MissionQuestionCard({
    super.key,
    required this.questionNumber,
    required this.category,
    required this.duration,
    required this.question,
    required this.focus,
    this.categoryColor = const Color(0xFF6366F1),
    this.categoryBgColor = const Color(0xFFEEF2FF),
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: isActive
            ? Border.all(
                color: const Color(0xFF6366F1).withAlpha(100),
                width: 2,
              )
            : Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: const Color(0xFF6366F1).withAlpha(20),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF6366F1)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    questionNumber,
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFF64748B),
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                BriefingTag(
                  label: category.toUpperCase(),
                  backgroundColor: categoryBgColor,
                  textColor: categoryColor,
                ),
                const Spacer(),
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: const Color(0xFF64748B).withAlpha(150),
                ),
                const SizedBox(width: 6),
                Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F5F9), height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.light_mode_rounded,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Focus: $focus',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.groups_rounded,
                    label: 'HR Insight',
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.auto_awesome_rounded,
                    label: 'Boost Answer',
                    isPrimary: true,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFFFFF1F2) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isPrimary
                ? const Color(0xFFFECDD3)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isPrimary
                  ? const Color(0xFFFB7185)
                  : const Color(0xFF64748B),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isPrimary
                    ? const Color(0xFFE11D48)
                    : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
