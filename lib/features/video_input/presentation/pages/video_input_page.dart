import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_interview_ai/core/helper/log_helper.dart';
import 'package:smart_interview_ai/core/helper/presentation_helper.dart';
import 'package:smart_interview_ai/features/audio_input/services/whisper_service.dart';
import 'package:smart_interview_ai/features/video_input/presentation/widgets/video_control_actions.dart';
import 'package:smart_interview_ai/features/video_input/presentation/widgets/video_preview_widget.dart';

@RoutePage()
class VideoInputPage extends StatefulWidget {
  const VideoInputPage({super.key});

  @override
  State<VideoInputPage> createState() => _VideoInputPageState();
}

class _VideoInputPageState extends State<VideoInputPage> {
  CameraController? _cameraController;
  final WhisperService _whisperService = WhisperService();
  bool _isRecording = false;
  bool _isProcessing = false;
  String _transcribedText = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (status.isDenied || micStatus.isDenied) {
      if (mounted) {
        PresentationHelper.showImmediateSnackBar(
          context,
          const SnackBar(
            content: Text('Camera and Microphone permissions are required'),
          ),
        );
      }
      return;
    }

    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.max,
      enableAudio: true,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    try {
      await _cameraController?.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      Log.error("Camera initialization failed: $e");
    }
  }

  Future<void> _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      if (_cameraController!.value.isRecordingVideo) return;

      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _transcribedText = ''; // Clear previous text
      });
    } catch (e) {
      Log.error("Error starting recording: $e");
      if (mounted) {
        PresentationHelper.showImmediateSnackBar(
          context,
          const SnackBar(content: Text('Failed to start recording')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    if (_cameraController == null || !_isRecording) return;

    try {
      final XFile videoFile = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });

      final text = await _whisperService.transcribe(videoFile.path);

      if (mounted) {
        setState(() {
          _transcribedText = text;
          _isProcessing = false;
        });
      }
    } catch (e) {
      Log.error("Error stopping recording or transcribing: $e");
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        PresentationHelper.showImmediateSnackBar(
          context,
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Video Input'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.back(),
          tooltip: 'Back to Home',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: VideoPreviewWidget(controller: _cameraController),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Transcription:",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _transcribedText.isEmpty
                            ? (_isProcessing
                                  ? "Transcribing..."
                                  : "Record a video to see transcription here.")
                            : _transcribedText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            VideoControlActions(
              isRecording: _isRecording,
              isProcessing: _isProcessing,
              onStartRecording: _startRecording,
              onStopRecording: _stopRecording,
            ),
          ],
        ),
      ),
    );
  }
}
