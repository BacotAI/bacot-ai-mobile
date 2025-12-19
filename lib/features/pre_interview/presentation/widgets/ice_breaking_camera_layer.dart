import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:smart_interview_ai/features/on_interview/logic/interview_recorder_service.dart';

class IceBreakingCameraLayer extends StatelessWidget {
  final InterviewRecorderService recorderService;
  final bool isCameraInitialized;
  final bool isRecording;
  final AnimationController fadeController;
  final VoidCallback onToggleRecording;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const IceBreakingCameraLayer({
    super.key,
    required this.recorderService,
    required this.isCameraInitialized,
    required this.isRecording,
    required this.fadeController,
    required this.onToggleRecording,
    required this.onBack,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final bool showPlaceholder =
        !isCameraInitialized ||
        recorderService.cameraController == null ||
        !recorderService.cameraController!.value.isInitialized;

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Camera
        if (!showPlaceholder)
          FadeTransition(
            opacity: fadeController,
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: recorderService
                      .cameraController!
                      .value
                      .previewSize!
                      .height,
                  height: recorderService
                      .cameraController!
                      .value
                      .previewSize!
                      .width,
                  child: CameraPreview(recorderService.cameraController!),
                ),
              ),
            ),
          )
        else
          Container(
            color: Colors.grey[900],
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white24,
                strokeWidth: 2,
              ),
            ),
          ),

        // 3. UI
        SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              const Spacer(),
              // Affirmation Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  height: 120,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.3,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          blurRadius: 20,
                          color: Colors.black45,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      pause: const Duration(milliseconds: 500),
                      animatedTexts: [
                        FadeAnimatedText(
                          'SAYA\nKOMPETEN',
                          textAlign: TextAlign.center,
                          duration: const Duration(milliseconds: 1000),
                        ),
                        FadeAnimatedText(
                          'DAN SAYA\nSIAP!',
                          textAlign: TextAlign.center,
                          duration: const Duration(milliseconds: 1000),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // Bottom Card
              _buildRecordingControlCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlassIconButton(icon: Icons.close_rounded, onTap: onBack),
          _buildGlassTextButton(
            text: "Skip",
            icon: Icons.arrow_forward_rounded,
            onTap: onSkip,
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingControlCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(26),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withAlpha(51), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Katakan dengan lantang 3x",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onToggleRecording,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRecording
                          ? Colors.redAccent
                          : Colors.white,
                      foregroundColor: isRecording
                          ? Colors.white
                          : Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isRecording
                              ? Icons.stop_rounded
                              : Icons.fiber_manual_record_rounded,
                          size: 24,
                          color: isRecording ? Colors.white : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isRecording ? "Stop" : "Mulai",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildGlassTextButton({
    required String text,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(38),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withAlpha(51), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
