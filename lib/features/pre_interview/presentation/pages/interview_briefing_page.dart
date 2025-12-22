import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../widgets/briefing_card.dart';
import '../widgets/briefing_tag.dart';
import '../widgets/pulse_animation.dart';
import '../widgets/preparation_help_bottom_sheet.dart';
import '../../../../app/router/app_router.gr.dart';

@RoutePage()
class InterviewBriefingPage extends StatelessWidget {
  const InterviewBriefingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF1F5F9),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF1E293B),
                size: 18,
              ),
              onPressed: () => context.router.back(),
            ),
          ),
        ),
        title: const Text(
          'Preparation',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => PreparationHelpBottomSheet.show(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'Help',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Briefing Dulu',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E293B),
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                PulseAnimation(
                  pulseColor: const Color(0xFF0EA5E9),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0F2FE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.access_time_filled_rounded,
                      size: 14,
                      color: Color(0xFF0EA5E9),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Durasi: 15 min',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            BriefingCard(
              title: 'Ice Breaking',
              description: 'Yuk pemanasan dulu',
              tags: const [
                BriefingTag(
                  label: 'WARM-UP',
                  backgroundColor: Color(0xFFF1F5F9),
                  textColor: Color(0xFF64748B),
                ),
              ],
              icon: const Icon(
                Icons.ice_skating_rounded,
                color: Color(0xFF94A3B8),
                size: 24,
              ),
              actionLabel: 'Mulai',
              actionIcon: Icons.arrow_forward_rounded,
              onActionPressed: () =>
                  context.router.push(const MissionBriefingRoute()),
            ),
            BriefingCard(
              title: 'Collaboration',
              description:
                  'Ceritakan pengalaman kamu berkolaborasi dengan tim.',
              isActive: true,
              tags: const [
                BriefingTag(
                  label: 'BEHAVIORAL',
                  backgroundColor: Color(0xFFE0F2FE),
                  textColor: Color(0xFF0EA5E9),
                ),
                BriefingTag(
                  label: 'HARD',
                  backgroundColor: Color(0xFFFEF2F2),
                  textColor: Color(0xFFEF4444),
                ),
              ],
              icon: const Icon(
                Icons.radio_button_checked_rounded,
                color: Color(0xFF0EA5E9),
                size: 24,
              ),
            ),
            BriefingCard(
              title: 'Question 2',
              description:
                  'Explain a complex technical concept to a non-technical audience.',
              isLocked: true,
              tags: const [
                BriefingTag(
                  label: 'TECHNICAL',
                  backgroundColor: Color(0xFFF1F5F9),
                  textColor: Color(0xFF64748B),
                ),
                BriefingTag(
                  label: 'MEDIUM',
                  backgroundColor: Color(0xFFF1F5F9),
                  textColor: Color(0xFF64748B),
                ),
              ],
              icon: const Icon(
                Icons.lock_rounded,
                color: Color(0xFF94A3B8),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
