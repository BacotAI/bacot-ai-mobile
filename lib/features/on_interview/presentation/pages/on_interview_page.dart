import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/features/pre_interview/domain/entities/question_entity.dart';
import '../cubit/on_interview_cubit.dart';
import '../cubit/on_interview_state.dart';
import '../widgets/camera_overlay.dart';
import '../../logic/interview_recorder_service.dart';

@RoutePage()
class OnInterviewPage extends StatefulWidget {
  final QuestionEntity question;

  const OnInterviewPage({super.key, required this.question});

  @override
  State<OnInterviewPage> createState() => _OnInterviewPageState();
}

class _OnInterviewPageState extends State<OnInterviewPage> {
  // Manually managing permissions here for simplicity
  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();

    if (cameraStatus.isDenied || microphoneStatus.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera and Microphone permissions are required.'),
          ),
        );
        context.router.back();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OnInterviewCubit>()..initialize(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocConsumer<OnInterviewCubit, OnInterviewState>(
          listener: (context, state) {
            if (state is OnInterviewFinished) {
              // TODO: Navigate to results page
              // For now, just show dialog and go back
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Interview Selesai'),
                  content: Text(
                    'Skor Mata: ${(state.finalResult.eyeContactScore * 100).toInt()}%\n'
                    'Feedback: ${state.finalResult.feedbackMessage}',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.router.popUntilRouteWithName(
                          'PreInterviewRoute',
                        );
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
            if (state is OnInterviewError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // Camera Preview
                // We need to access the controller.
                // Since we registered the service as LazySingleton, we can get it.
                // Ideally, we should use a FutureBuilder for the controller initialization from the service
                // BUT the Cubit handles initialization.

                // Let's use a Layout that checks if controller is ready
                // Since we don't expose controller in state, we might need to access the service.
                _CameraView(),

                // Overlay
                if (state is OnInterviewCountdown)
                  InterviewOverlay(
                    questionText: widget.question.text,
                    countdown: state.validDuration,
                  )
                else if (state is OnInterviewRecording)
                  InterviewOverlay(
                    questionText: widget.question.text,
                    elapsedSeconds: state.elapsedSeconds,
                    feedback: state.lastScoringResult,
                    onStopPressed: () =>
                        context.read<OnInterviewCubit>().stopRecording(),
                  )
                else if (state is OnInterviewProcessing)
                  const Center(child: CircularProgressIndicator())
                else if (state is OnInterviewInitial ||
                    state is OnInterviewLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Widget to handle camera preview independently
// Widget to handle camera preview independently
class _CameraView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the singleton service
    final recorder = sl<InterviewRecorderService>();
    final controller = recorder.cameraController;

    if (controller != null && controller.value.isInitialized) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width:
                controller.value.previewSize?.height ??
                MediaQuery.of(context).size.width,
            height:
                controller.value.previewSize?.width ??
                MediaQuery.of(context).size.height,
            child: CameraPreview(controller),
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
