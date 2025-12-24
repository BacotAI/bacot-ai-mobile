import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_interview_ai/core/utils/sizes.dart';
import 'package:smart_interview_ai/core/widgets/button/start_interview_button.dart';
import '../widgets/mission_question_card.dart';
import '../widgets/mission_help_bottom_sheet.dart';

@RoutePage()
class MissionBriefingPage extends StatelessWidget {
  const MissionBriefingPage({super.key});

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

                const MissionQuestionCard(
                  questionNumber: '01',
                  category: 'Perilaku',
                  duration: '3 min',
                  isActive: true,
                  question:
                      'Ceritakan pengalaman Anda saat menangani konflik dengan rekan kerja.',
                  categoryBgColor: Color(0xFFEEF2FF),
                  categoryColor: Color(0xFF6366F1),
                ),
                const MissionQuestionCard(
                  questionNumber: '02',
                  category: 'Strategi',
                  duration: '5 min',
                  categoryBgColor: Color(0xFFF5F3FF),
                  categoryColor: Color(0xFF8B5CF6),
                  question:
                      'Deskripsikan produk yang Anda manajemen yang gagal memenuhi harapan.',
                ),
                const MissionQuestionCard(
                  questionNumber: '03',
                  category: 'Prioritasi',
                  duration: '4 min',
                  categoryBgColor: Color(0xFFF5F3FF),
                  categoryColor: Color(0xFF8B5CF6),
                  question:
                      'Bagaimana Anda menentukan fitur apa yang akan dibangun selanjutnya ketika sumber daya terbatas?',
                ),
                const MissionQuestionCard(
                  questionNumber: '04',
                  category: 'Visi',
                  duration: '5 min',
                  categoryBgColor: Color(0xFFF5F3FF),
                  categoryColor: Color(0xFF8B5CF6),
                  question:
                      'Di mana Anda melihat industri akan bergerak selama 5 tahun mendatang?',
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          _buildFloatingStartButton(isDisabled: true),
        ],
      ),
    );
  }

  Widget _buildFloatingStartButton({bool isDisabled = false}) {
    return Positioned(
      bottom: SizesApp.margin * 2,
      left: 24,
      right: 24,
      child: StartInterviewButton(
        label: 'START',
        isDisabled: isDisabled,
        leftIcon: Icons.lock_outline,
        rightIcon: Icons.arrow_forward_rounded,
        onTap: () {
          // TODO: Implement start logic
        },
      ),
    );
  }
}
