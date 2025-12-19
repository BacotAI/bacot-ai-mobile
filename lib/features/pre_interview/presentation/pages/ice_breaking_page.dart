import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/app/router/app_router.gr.dart';
import 'package:smart_interview_ai/features/pre_interview/domain/entities/question_entity.dart';
import 'package:smart_interview_ai/features/on_interview/logic/interview_recorder_service.dart';

@RoutePage()
class IceBreakingPage extends StatefulWidget {
  final QuestionEntity question;

  const IceBreakingPage({super.key, required this.question});

  @override
  State<IceBreakingPage> createState() => _IceBreakingPageState();
}

class _IceBreakingPageState extends State<IceBreakingPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late InterviewRecorderService _recorderService;
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _recorderService = sl<InterviewRecorderService>();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final statuses = await [Permission.camera, Permission.microphone].request();

    if (statuses[Permission.camera]!.isGranted &&
        statuses[Permission.microphone]!.isGranted) {
      try {
        await _recorderService.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
          _fadeController.forward();
        }
      } catch (e) {
        debugPrint('Error initializing camera: $e');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera and Microphone permissions are required'),
          ),
        );
      }
    }
  }

  Future<void> _toggleRecording() async {
    if (_recorderService.cameraController == null ||
        !_recorderService.cameraController!.value.isInitialized) {
      return;
    }

    try {
      if (_isRecording) {
        await _recorderService.cameraController!.stopVideoRecording();
        setState(() => _isRecording = false);
      } else {
        await _recorderService.cameraController!.startVideoRecording();
        setState(() => _isRecording = true);
      }
    } catch (e) {
      debugPrint('Error toggling recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error recording: $e')));
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _fadeController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      // Optional: Handle camera pause if needed
    } else if (state == AppLifecycleState.resumed) {
      // Optional: Handle camera resume if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showPlaceholder =
        !_isCameraInitialized ||
        _recorderService.cameraController == null ||
        !_recorderService.cameraController!.value.isInitialized;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Camera Layer
          if (!showPlaceholder)
            FadeTransition(
              opacity: _fadeController,
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _recorderService
                        .cameraController!
                        .value
                        .previewSize!
                        .height,
                    height: _recorderService
                        .cameraController!
                        .value
                        .previewSize!
                        .width,
                    child: CameraPreview(_recorderService.cameraController!),
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

          // 2. Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // 3. Main Content
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGlassIconButton(
                        icon: Icons.close_rounded,
                        onTap: () => context.router.back(),
                      ),
                      _buildGlassTextButton(
                        text: "Mulai Interview",
                        icon: Icons.arrow_forward_rounded,
                        onTap: () {
                          context.router.replace(
                            OnInterviewRoute(question: widget.question),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Center Affirmation Text
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

                // Bottom Instruction & Action Card
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
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
                            // Record Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _toggleRecording,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isRecording
                                      ? Colors.redAccent
                                      : Colors.white,
                                  foregroundColor: _isRecording
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
                                      _isRecording
                                          ? Icons.stop_rounded
                                          : Icons.fiber_manual_record_rounded,
                                      size: 24,
                                      color: _isRecording
                                          ? Colors.white
                                          : Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _isRecording ? "Stop Recording" : "Rekam",
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
                ),
              ],
            ),
          ),
        ],
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
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
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
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
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
