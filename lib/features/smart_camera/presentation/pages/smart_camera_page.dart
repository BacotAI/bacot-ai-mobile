import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_interview_ai/features/smart_camera/services/pose_detector_service.dart';
import 'package:smart_interview_ai/features/smart_camera/services/object_detector_service.dart';
import 'package:smart_interview_ai/features/smart_camera/presentation/widgets/header.dart';
import 'package:smart_interview_ai/features/smart_camera/presentation/widgets/pose_painter.dart';
import 'package:smart_interview_ai/features/smart_camera/logic/posture_validator.dart';
import 'package:smart_interview_ai/features/smart_camera/services/face_detector_service.dart';
import 'package:smart_interview_ai/features/smart_camera/presentation/widgets/face_painter.dart';
import 'package:smart_interview_ai/features/smart_camera/presentation/widgets/smart_camera_bottom_actions.dart';
import 'package:smart_interview_ai/features/smart_camera/logic/expression_detector.dart';
import 'package:smart_interview_ai/features/smart_camera/models/expression_data.dart';
import 'package:smart_interview_ai/features/smart_camera/presentation/widgets/expression_chart.dart';
import 'package:smart_interview_ai/features/smart_camera/presentation/widgets/instructional_overlay_text.dart';

import 'package:smart_interview_ai/core/config/app_colors.dart';

@RoutePage()
class SmartCameraPage extends StatefulWidget {
  const SmartCameraPage({super.key});

  @override
  State<SmartCameraPage> createState() => _SmartCameraPageState();
}

class _SmartCameraPageState extends State<SmartCameraPage> {
  CameraController? _cameraController;
  late final PoseDetectorService _poseDetectorService;
  late final FaceDetectorService _faceDetectorService;
  late final ObjectDetectorService _objectDetectorService;
  CameraMode _mode = CameraMode.pose;
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  ExpressionData? _expressionData;
  final _cameraLensDirection = CameraLensDirection.front;

  @override
  void initState() {
    super.initState();
    _poseDetectorService = PoseDetectorService();
    _faceDetectorService = FaceDetectorService();
    _objectDetectorService = ObjectDetectorService();
    _initializeCamera();
  }

  @override
  void dispose() {
    _canProcess = false;
    _poseDetectorService.dispose();
    _faceDetectorService.dispose();
    _objectDetectorService.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required')),
        );
      }
      return;
    }

    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == _cameraLensDirection,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    try {
      await _cameraController?.initialize();
      if (!mounted) return;
      await _cameraController?.startImageStream(_processImage);
      setState(() {});
    } catch (e) {
      debugPrint("Camera initialization failed: $e");
    }
  }

  Future<void> _processImage(CameraImage image) async {
    if (!_canProcess || _isBusy || _cameraController == null) return;
    _isBusy = true;

    try {
      final inputImage = switch (_mode) {
        CameraMode.pose => _poseDetectorService.inputImageFromCameraImage(
          image: image,
          camera: _cameraController!.description,
          deviceOrientation: _cameraController!.value.deviceOrientation,
        ),
        CameraMode.face => _faceDetectorService.inputImageFromCameraImage(
          image: image,
          camera: _cameraController!.description,
          deviceOrientation: _cameraController!.value.deviceOrientation,
        ),
        CameraMode.object => _objectDetectorService.inputImageFromCameraImage(
          image: image,
          camera: _cameraController!.description,
          deviceOrientation: _cameraController!.value.deviceOrientation,
        ),
      };

      if (inputImage == null) {
        _isBusy = false;
        return;
      }

      if (_mode == CameraMode.pose) {
        final poses = await _poseDetectorService.processImage(inputImage);
        if (mounted) {
          final screenSize = MediaQuery.of(context).size;
          final validationResult = PostureValidator.validate(
            poses: poses,
            imageSize: Size(image.width.toDouble(), image.height.toDouble()),
            screenSize: screenSize,
            rotation:
                inputImage.metadata?.rotation ??
                InputImageRotation.rotation270deg,
            cameraLensDirection: _cameraLensDirection,
          );

          String message = "";
          switch (validationResult) {
            case PostureValidationStatus.aligned:
              message = "Sempurna! pertahankan!!!.";
              break;
            case PostureValidationStatus.shouldersNotAligned:
              message = "Tempatkan bahu Anda di dalam siluet";
              break;
            case PostureValidationStatus.headNotAligned:
              message = "Tempatkan kepala di dalam siluet";
              break;
            case PostureValidationStatus.notDetecting:
              message = "Kamu dimana??";
              break;
            default:
              message = "Posisikan tubuhmu";
          }

          setState(() {
            _text = message;
            _customPaint = CustomPaint(
              painter: PosePainter(
                poses: poses,
                imageSize: Size(
                  image.width.toDouble(),
                  image.height.toDouble(),
                ),
                rotation: InputImageRotation.rotation0deg,
                cameraLensDirection: _cameraLensDirection,
                validationStatus: validationResult,
              ),
            );
          });
        }
      }

      if (_mode == CameraMode.face) {
        final faces = await _faceDetectorService.processImage(inputImage);
        if (mounted) {
          setState(() {
            _text = faces.isNotEmpty
                ? "Wajah terdeteksi: ${faces.length}"
                : "Mencari wajah...";

            if (faces.isNotEmpty) {
              _expressionData = ExpressionDetector.detect(faces.first);
            } else {
              _expressionData = null;
            }

            _customPaint = CustomPaint(
              painter: FacePainter(
                faces: faces,
                imageSize: Size(
                  image.width.toDouble(),
                  image.height.toDouble(),
                ),
                rotation: InputImageRotation.rotation0deg,
                cameraLensDirection: _cameraLensDirection,
              ),
            );
          });
        }
      }

      if (_mode == CameraMode.object) {
        final result = await _objectDetectorService.processImage(inputImage);

        if (mounted && result != null) {
          //TODO: masker detection still not working
          setState(() {
            switch ((result.hasMask, result.hasCap)) {
              case (true, true):
                _text = "Masker & Topi Terdeteksi! Mohon dilepas.";
                break;
              case (true, false):
                _text = "Masker Terdeteksi! Mohon dilepas.";
                break;
              case (false, true):
                _text = "Topi Terdeteksi! Mohon dilepas.";
                break;
              default:
                _text = null;
                break;
            }
            _customPaint = null;
          });
        }
      }
    } catch (e) {
      debugPrint("Error processing image: $e");
    } finally {
      _isBusy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _cameraController!.value.aspectRatio;

    if (scale < 1) scale = 1 / scale;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Header(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate scale to ensure BoxFit.cover behavior within this container
                    final size = Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );
                    var scale =
                        size.aspectRatio * _cameraController!.value.aspectRatio;
                    if (scale < 1) scale = 1 / scale;

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.textPrimary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Transform.scale(
                              scale: scale,
                              child: Center(
                                child: CameraPreview(_cameraController!),
                              ),
                            ),
                            if (_customPaint != null) _customPaint!,

                            // Visual Expression Chart
                            if (_mode == CameraMode.face &&
                                _expressionData != null)
                              Positioned(
                                top: 20,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: ExpressionChart(
                                    data: _expressionData!,
                                  ),
                                ),
                              ),

                            if (_mode == CameraMode.pose ||
                                _mode == CameraMode.object)
                              if (_text != null && _text!.isNotEmpty)
                                InstructionalOverlayText(text: _text)
                              else
                                InstructionalOverlayText(
                                  child: Center(
                                    child: DefaultTextStyle(
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: AppColors.textSecondary,
                                      ),
                                      child: AnimatedTextKit(
                                        animatedTexts: [
                                          TyperAnimatedText(
                                            '....',
                                            speed: const Duration(
                                              milliseconds: 250,
                                            ),
                                          ),
                                        ],
                                        repeatForever: true,
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SmartCameraBottomActions(
                mode: _mode,
                onModeChanged: (newMode) {
                  setState(() {
                    _mode = newMode;
                    _text = null;
                    _customPaint = null;
                    _expressionData = null;
                    _isBusy = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
