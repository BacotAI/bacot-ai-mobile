import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_interview_ai/app/router/app_router.gr.dart';
import 'package:smart_interview_ai/core/utils/sizes.dart';
import 'package:smart_interview_ai/core/widgets/button/start_interview_button.dart';
import 'package:smart_interview_ai/domain/pre_interview/entities/question_entity.dart';
import 'package:smart_interview_ai/presentation/pre_interview/widgets/mission_help_bottom_sheet.dart';
import 'package:smart_interview_ai/presentation/pre_interview/widgets/mission_question_card.dart';

@RoutePage()
class MissionBriefingPage extends StatelessWidget {
  const MissionBriefingPage({super.key});

  static const List<QuestionEntity> mockQuestions = [
    QuestionEntity(
      id: '1',
      text:
          'Ceritakan pengalaman Anda saat menangani konflik dengan rekan kerja.',
      hrInsight:
          'Mengukur kemampuan resolusi konflik dan kecerdasan emosional.',
      difficulty: QuestionDifficulty.tricky,
      estimatedDurationSeconds: 10,
      communityStats: '85% users found this helpful',
      powerWords: ['Conflict Resolution', 'Empathy', 'Communication'],
    ),
    QuestionEntity(
      id: '2',
      text:
          'Deskripsikan produk yang Anda manajemen yang gagal memenuhi harapan.',
      hrInsight: 'Mengukur kemampuan belajar dari kegagalan dan akuntabilitas.',
      difficulty: QuestionDifficulty.hard,
      estimatedDurationSeconds: 10,
      communityStats: '70% users struggled here',
      powerWords: ['Accountability', 'Learning', 'Pivoting'],
    ),
    // QuestionEntity(
    //   id: '3',
    //   text:
    //       'Bagaimana Anda menentukan fitur apa yang akan dibangun selanjutnya ketika sumber daya terbatas?',
    //   hrInsight: 'Mengukur kemampuan prioritas dan pengambilan keputusan.',
    //   difficulty: QuestionDifficulty.hard,
    //   estimatedDurationSeconds: 10,
    //   communityStats: '90% success rate with STAR method',
    //   powerWords: ['Prioritization', 'ROI', 'Data-driven'],
    // ),
    // QuestionEntity(
    //   id: '4',
    //   text:
    //       'Di mana Anda melihat industri akan bergerak selama 5 tahun mendatang?',
    //   hrInsight: 'Mengukur visi strategis dan pengetahuan sektor.',
    //   difficulty: QuestionDifficulty.hard,
    //   estimatedDurationSeconds: 10,
    //   communityStats: 'New question',
    //   powerWords: ['Strategic Vision', 'Innovation', 'Market Trends'],
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => MissionHelpBottomSheet.show(context),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Interview Questions',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: SizesApp.margin / 2),
                const Text(
                  'Tinjau pertanyaan Anda dan siapkan jawaban sebelum memulai wawancara.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: SizesApp.margin * 1.5),

                ...mockQuestions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final q = entry.value;
                  return MissionQuestionCard(
                    questionNumber: (index + 1).toString().padLeft(2, '0'),
                    category: q.difficulty == QuestionDifficulty.hard
                        ? 'Strategi'
                        : 'Perilaku',
                    duration: '${q.estimatedDurationSeconds ~/ 60} min',
                    isActive: index == 0,
                    question: q.text,
                    categoryBgColor: index == 0
                        ? const Color(0xFFEEF2FF)
                        : const Color(0xFFF5F3FF),
                    categoryColor: index == 0
                        ? const Color(0xFF6366F1)
                        : const Color(0xFF8B5CF6),
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Positioned(
            bottom: SizesApp.margin * 2,
            left: 24,
            right: 24,
            child: StartInterviewButton(
              label: 'START',
              isDisabled: false,
              rightIcon: Icons.arrow_forward_rounded,
              onTap: () {
                context.router.push(OnInterviewRoute(questions: mockQuestions));
              },
            ),
          ),
        ],
      ),
    );
  }
}
