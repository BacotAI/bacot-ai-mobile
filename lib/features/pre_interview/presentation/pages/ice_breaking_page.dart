import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/app/router/app_router.gr.dart';
import 'package:smart_interview_ai/core/helper/log_helper.dart';
import 'package:smart_interview_ai/features/pre_interview/domain/entities/question_entity.dart';
import 'package:smart_interview_ai/features/pre_interview/presentation/widgets/draw_stars.dart';
import 'package:smart_interview_ai/features/pre_interview/presentation/widgets/ice_breaking_camera_layer.dart';
import 'package:smart_interview_ai/features/pre_interview/presentation/widgets/ice_breaking_preview_layer.dart';
import 'package:smart_interview_ai/features/pre_interview/presentation/widgets/ice_breaking_transition_overlay.dart';
import 'package:smart_interview_ai/features/on_interview/logic/interview_recorder_service.dart';
import 'package:smart_interview_ai/core/helper/presentation_helper.dart';
import 'package:smart_interview_ai/core/presentation/widgets/custom_snackbar.dart';
import 'package:video_player/video_player.dart';

@RoutePage()
class IceBreakingPage extends StatefulWidget {
  final QuestionEntity question;

  const IceBreakingPage({super.key, required this.question});

  @override
  State<IceBreakingPage> createState() => _IceBreakingPageState();
}

class _IceBreakingPageState extends State<IceBreakingPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late InterviewRecorderService _recorderService;
  VideoPlayerController? _videoController;
  late ConfettiController _confettiController;

  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _checklistController;
  late AnimationController _exitController;

  bool _isCameraInitialized = false;
  bool _isRecording = false;
  bool _isPreview = false;
  bool _isExiting = false;
  XFile? _recordedVideo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _recorderService = sl<InterviewRecorderService>();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _checklistController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
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
        Log.error('Error initializing camera: $e');
      }
    } else {
      if (mounted) {
        if (mounted) {
          PresentationHelper.showCustomSnackBar(
            context: context,
            message: 'Camera and Microphone permissions are required',
            type: SnackbarType.error,
          );
        }
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
        // STOP RECORDING
        final file = await _recorderService.cameraController!
            .stopVideoRecording();

        setState(() {
          _isRecording = false;
          _recordedVideo = file;
          _isPreview = true;
        });

        // Initialize Video Player
        _videoController = VideoPlayerController.file(File(file.path))
          ..initialize().then((_) {
            _videoController!.play();
            _videoController!.setLooping(true);
            setState(() {});
          });

        // Trigger Celebrations
        _confettiController.play();
        _checklistController.forward();
      } else {
        // START RECORDING
        await _recorderService.cameraController!.startVideoRecording();
        setState(() => _isRecording = true);
      }
    } catch (e) {
      Log.error('Error toggling recording: $e');
      if (mounted) {
        PresentationHelper.showCustomSnackBar(
          context: context,
          message: 'Error recording: $e',
          type: SnackbarType.error,
        );
      }
    }
  }

  Future<void> finishIceBreaking() async {
    setState(() => _isExiting = true);
    await _exitController.forward();

    _videoController?.dispose();
    _videoController = null;

    if (_recordedVideo != null) {
      try {
        await File(_recordedVideo!.path).delete();
        if (mounted) {
          PresentationHelper.showCustomSnackBar(
            context: context,
            message: 'Ice breaking selesai',
            type: SnackbarType.success,
          );
        }
      } catch (e) {
        Log.error("Error deleting file: $e");
      }
    }

    if (mounted) {
      context.router.replace(PreInterviewRoute());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _fadeController.dispose();
    _checklistController.dispose();
    _exitController.dispose();
    _confettiController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _recorderService.cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // CONTENT LAYER
          if (_isPreview &&
              _videoController != null &&
              _videoController!.value.isInitialized)
            IceBreakingPreviewLayer(
              videoController: _videoController!,
              checklistController: _checklistController,
              onFinish: finishIceBreaking,
              onSkip: () => context.router.replace(
                OnInterviewRoute(question: widget.question),
              ),
              onBack: finishIceBreaking,
            )
          else
            IceBreakingCameraLayer(
              recorderService: _recorderService,
              isCameraInitialized: _isCameraInitialized,
              isRecording: _isRecording,
              fadeController: _fadeController,
              onToggleRecording: _toggleRecording,
              onBack: () => context.router.back(),
              onSkip: () {
                context.router.replace(
                  OnInterviewRoute(question: widget.question),
                );
              },
            ),

          // EXIT ANIMATION OVERLAY
          if (_isExiting)
            IceBreakingTransitionOverlay(exitController: _exitController),

          // CONFETTI LAYER
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
              createParticlePath: drawStar,
            ),
          ),
        ],
      ),
    );
  }
}
