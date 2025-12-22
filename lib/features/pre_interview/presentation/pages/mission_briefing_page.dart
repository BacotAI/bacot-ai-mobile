import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_interview_ai/core/utils/sizes.dart';
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
          'MISSION',
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
            const Text(
              'Pertanyaan',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: SizesApp.margin),
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
                        'Perhatikan pertanyaanmu sebelum waktu dimulai. Gunakan ',
                  ),
                  TextSpan(
                    text: 'STAR method',
                    style: TextStyle(
                      color: const Color(0xFF6366F1),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const TextSpan(text: ' untuk hasil jawaban yang memuaskan.'),
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
                  'Bicarakan tentang suatu waktu Anda mengatasi konflik dengan seorang rekan kerja.',
              focus: 'Penyelesaian Konflik, Empati',
            ),
            MissionQuestionCard(
              questionNumber: 'Q2',
              category: 'Strategy',
              duration: '5 min',
              categoryBgColor: const Color(0xFFF1F5F9),
              categoryColor: const Color(0xFF64748B),
              question:
                  'Bicarakan tentang suatu produk yang Anda manajemen yang tidak memenuhi harapan.',
              focus: 'Retrospective, Learning',
            ),
            MissionQuestionCard(
              questionNumber: 'Q3',
              category: 'Prioritization',
              duration: '4 min',
              categoryBgColor: const Color(0xFFF1F5F9),
              categoryColor: const Color(0xFF64748B),
              question:
                  'Bicarakan tentang suatu waktu Anda menentukan fitur apa yang akan dibangun selanjutnya ketika sumber daya terbatas.',
              focus: 'Decision Making, ROI',
            ),
            MissionQuestionCard(
              questionNumber: 'Q4',
              category: 'Vision',
              duration: '5 min',
              categoryBgColor: const Color(0xFFF1F5F9),
              categoryColor: const Color(0xFF64748B),
              question:
                  'Bicarakan tentang suatu waktu Anda menentukan fitur apa yang akan dibangun selanjutnya ketika sumber daya terbatas.',
              focus: 'Decision Making, ROI',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
