import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../widgets/mission_question_card.dart';
import '../widgets/mission_help_bottom_sheet.dart';

@RoutePage()
class MissionBriefingPage extends StatelessWidget {
  const MissionBriefingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => context.router.back(),
        ),
        title: const Text(
          'BRIEFING',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => MissionHelpBottomSheet.show(context),
            child: const Text(
              'Help',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: const Color(0xFFE0E7FF)),
                  ),
                  child: const Text(
                    'STEP 2 OF 3',
                    style: TextStyle(
                      color: Color(0xFF6366F1),
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Product Manager Role',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Mission Briefing',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  const TextSpan(
                    text:
                        'Review your questions before the timer starts. Use the ',
                  ),
                  TextSpan(
                    text: 'STAR method',
                    style: TextStyle(
                      color: const Color(0xFF6366F1),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const TextSpan(
                    text: ' to structure your answers effectively.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const MissionQuestionCard(
              questionNumber: 'Q1',
              category: 'Behavioral',
              duration: '3 min',
              isActive: true,
              question:
                  'Tell me about a time you handled a conflict with a coworker.',
              focus: 'Conflict Resolution, Empathy',
            ),
            MissionQuestionCard(
              questionNumber: 'Q2',
              category: 'Strategy',
              duration: '5 min',
              categoryBgColor: const Color(0xFFF1F5F9),
              categoryColor: const Color(0xFF64748B),
              question:
                  'Describe a product you managed that failed to meet expectations.',
              focus: 'Retrospective, Learning',
            ),
            MissionQuestionCard(
              questionNumber: 'Q3',
              category: 'Prioritization',
              duration: '4 min',
              categoryBgColor: const Color(0xFFF1F5F9),
              categoryColor: const Color(0xFF64748B),
              question:
                  'How do you decide what features to build next when resources are limited?',
              focus: 'Decision Making, ROI',
            ),
            MissionQuestionCard(
              questionNumber: 'Q4',
              category: 'Vision',
              duration: '5 min',
              categoryBgColor: const Color(0xFFF1F5F9),
              categoryColor: const Color(0xFF64748B),
              question:
                  'Where do you see the industry going in the next 5 years?',
              focus: 'Market Awareness',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
