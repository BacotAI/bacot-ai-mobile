import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class IceBreakingPreviewLayer extends StatelessWidget {
  final VideoPlayerController videoController;
  final AnimationController checklistController;
  final VoidCallback onFinish;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  const IceBreakingPreviewLayer({
    super.key,
    required this.videoController,
    required this.checklistController,
    required this.onFinish,
    required this.onSkip,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    // "Hollywood" Filter Matrix
    const double sat = 1.1;
    const List<double> matrix = [
      sat,
      0,
      0,
      0,
      0,
      0,
      sat,
      0,
      0,
      0,
      0,
      0,
      sat,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];

    return Container(
      color: Colors.black, // Sleek dark background
      child: Stack(
        children: [
          // Background Gradient Mesh (Subtle)
          Positioned(
            top: -100,
            right: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent.withAlpha(50),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purpleAccent.withAlpha(40),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 10),

                  // Header Title
                  FadeTransition(
                    opacity: checklistController.drive(
                      CurveTween(
                        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
                      ),
                    ),
                    child: _buildHeader(),
                  ),

                  const SizedBox(height: 32),

                  // Video Card
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: Hero(
                        tag: 'preview_card',
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withAlpha(60),
                                blurRadius: 40,
                                offset: const Offset(0, 10),
                                spreadRadius: -5,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white24,
                              width: 1.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: AspectRatio(
                              aspectRatio: 9 / 16, // Portrait ratio
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ColorFiltered(
                                    colorFilter: const ColorFilter.matrix(
                                      matrix,
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: SizedBox(
                                        width: videoController.value.size.width,
                                        height:
                                            videoController.value.size.height,
                                        child: VideoPlayer(videoController),
                                      ),
                                    ),
                                  ),
                                  // Inner Gradient for text readability
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black12,
                                            Colors.transparent,
                                            Colors.black.withAlpha(100),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // "Confidence Signal" Badge inside the video card at bottom
                                  Positioned(
                                    bottom: 16,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: FadeTransition(
                                        opacity: checklistController.drive(
                                          CurveTween(
                                            curve: const Interval(
                                              0.2,
                                              0.6,
                                              curve: Curves.easeOut,
                                            ),
                                          ),
                                        ),
                                        child: _buildMetricBadge(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Checklist
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildChecklistItem("Suara terdengar jelas", 0.4),
                        _buildChecklistItem("Pencahayaan oke", 0.5),
                        _buildChecklistItem("Anda terlihat percaya diri", 0.6),
                      ],
                    ),
                  ),

                  _buildActionButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          "VIBE CHECK PASSED",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            color: Colors.greenAccent,
          ),
        ),
        const SizedBox(height: 8),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            "Sepertinya kamu sudah siap!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricBadge() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black45, // Glass effect
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bolt_rounded, color: Colors.amber, size: 18),
              const SizedBox(width: 8),
              Text(
                "Confidence: STRONG",
                style: TextStyle(
                  color: Colors.white.withAlpha(230),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String text, double startInterval) {
    return FadeTransition(
      opacity: checklistController.drive(
        CurveTween(
          curve: Interval(
            startInterval,
            startInterval + 0.4,
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: SlideTransition(
        position: checklistController.drive(
          Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).chain(
            CurveTween(
              curve: Interval(
                startInterval,
                startInterval + 0.4,
                curve: Curves.easeOut,
              ),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.greenAccent,
                ),
                child: const Icon(Icons.check, color: Colors.black, size: 12),
              ),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return SlideTransition(
      position: checklistController.drive(
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).chain(
          CurveTween(curve: const Interval(0.6, 1.0, curve: Curves.elasticOut)),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: onFinish,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 20,
            shadowColor: Colors.blueAccent.withAlpha(100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Mulai Interview",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: _buildGlassIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: onBack,
        ),
      ),
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(38),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withAlpha(51), width: 1),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}
