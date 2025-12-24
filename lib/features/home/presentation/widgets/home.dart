import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_interview_ai/app/router/app_router.gr.dart';
import 'package:smart_interview_ai/features/home/presentation/widgets/card_home.dart';
import 'package:smart_interview_ai/features/home/presentation/widgets/feature_card.dart';
import 'package:smart_interview_ai/features/home/presentation/widgets/header_home.dart';
import 'package:smart_interview_ai/features/home/presentation/widgets/mock_interview_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: HeaderHome(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: MockInterviewCard(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CardHome(
                        label: "Last Session",
                        description: "+5% vs avg",
                        score: "20",
                        isShow: CardHomes.topIcon,
                        icons: Icons.trending_up,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CardHome(
                        label: "Pace",
                        description: "+5% vs avg",
                        score: "85",
                        isShow: CardHomes.topIcon,
                        icons: Icons.speed,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: CardHome(
                  label: 'Daily Drop',
                  description: '"Tell me about a time you failed?"',
                  score: '',
                  isShow: CardHomes.cardMic,
                  icons: Icons.flash_on,
                  onMicPressed: () => context.router.push(AudioInputRoute()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    FeatureCard(
                      title: 'Audio Input',
                      subtitle: 'Rekam dan analisis audio',
                      icon: Icons.mic_rounded,
                      color: const Color(0xFF3B82F6), // Blue
                      onTap: () => context.router.push(
                        AudioInputRoute(),
                      ), // Will fix null later
                    ),
                    const SizedBox(height: 16),
                    FeatureCard(
                      title: 'Smart Camera',
                      subtitle: 'Analisis postur dan wajah real-time',
                      icon: Icons.face_retouching_natural_rounded,
                      color: const Color(0xFF8B5CF6), // Violet
                      onTap: () =>
                          context.router.push(const SmartCameraRoute()),
                    ),
                    const SizedBox(height: 16),
                    FeatureCard(
                      title: 'Pre-interview',
                      subtitle: 'Mulai dengan pilihan pertanyaan',
                      icon: Icons.menu_book_rounded,
                      color: const Color(0xFFF59E0B), // Amber
                      onTap: () =>
                          context.router.push(const PreInterviewRoute()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
