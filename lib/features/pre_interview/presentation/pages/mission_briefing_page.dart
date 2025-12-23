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
                _buildIcebreakingButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
          _buildFloatingStartButton(),
        ],
      ),
    );
  }

  Widget _buildIcebreakingButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_camera_front_outlined,
            size: 20,
            color: const Color(0xFF64748B).withAlpha(200),
          ),
          const SizedBox(width: 12),
          const Text(
            'Icebreaking Session',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingStartButton() {
    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withAlpha(50),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      const Spacer(),
                      const Text(
                        'Start Interview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'SESSION LOCKED & RECORDED UPON START',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF94A3B8).withAlpha(150),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
