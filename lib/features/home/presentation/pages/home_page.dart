import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/app/router/app_router.gr.dart';
import 'package:smart_interview_ai/features/home/presentation/widgets/feature_card.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                'Smart\nInterview AI',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E293B),
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 16),
              Text(
                'Metode Testing AI',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton(
                  onPressed: () async {
                    await DI.authRepository.logout();

                    if (!context.mounted) return;

                    context.router.replaceAll([const LoginRoute()]);
                  },
                  child: const Text(
                    "Keluar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Expanded(
                child: ListView(
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
            ],
          ),
        ),
      ),
    );
  }
}
