import 'package:flutter/material.dart';
import 'package:smart_interview_ai/core/widgets/divider/dashed_divider.dart';
import 'briefing_tag.dart';
import 'hr_insight_bottom_sheet.dart';

class MissionQuestionCard extends StatelessWidget {
  final String questionNumber;
  final String category;
  final String duration;
  final String question;
  final Color categoryColor;
  final Color categoryBgColor;
  final bool isActive;

  const MissionQuestionCard({
    super.key,
    required this.questionNumber,
    required this.category,
    required this.duration,
    required this.question,
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
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 24,
            offset: const Offset(0, 8),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    questionNumber.padLeft(2, '0').replaceAll('Q', ''),
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w700,
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
                  Icons.watch_later,
                  size: 16,
                  color: const Color(0xFF64748B),
                ),
                const SizedBox(width: 6),
                Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
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
                color: Color(0xFF0F172A),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24),
            const DashedDivider(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.lightbulb_outline,
                    label: 'HR Insight',
                    iconColor: const Color(0xFF06B6D4),
                    onPressed: () => HrInsightBottomSheet.show(
                      context,
                      isPremium: false,
                      question: question,
                      recruiterIntent:
                          'Recruiters ask this to test your maturity and composure. They want to verify you can de-escalate tension and move forward productively without holding grudges.',
                      strategyMethod: 'STAR method',
                      strategyDescription:
                          'Focus 70% of your response on the Actions taken.',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.rocket_launch_outlined,
                    label: 'Boost Answer',
                    iconColor: const Color(0xFF6366F1),
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
    Color iconColor = const Color(0xFF64748B),
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withAlpha(20), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
