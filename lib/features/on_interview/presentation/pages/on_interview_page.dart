import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/core/helper/presentation_helper.dart';
import 'package:smart_interview_ai/core/widgets/snackbar/custom_snackbar.dart';
import 'package:smart_interview_ai/features/pre_interview/domain/entities/question_entity.dart';
import '../cubit/on_interview_cubit.dart';
import '../cubit/on_interview_state.dart';
import '../widgets/interview_header.dart';
import '../widgets/interview_camera_card.dart';
import '../widgets/interview_indicators.dart';
import '../widgets/interview_question_overlay.dart';
import '../widgets/interview_tips_row.dart';
import '../widgets/interview_bottom_section.dart';
import '../widgets/interview_countdown_overlay.dart';

@RoutePage()
class OnInterviewPage extends StatefulWidget {
  final List<QuestionEntity> questions;

  const OnInterviewPage({super.key, required this.questions});

  @override
  State<OnInterviewPage> createState() => _OnInterviewPageState();
}

class _OnInterviewPageState extends State<OnInterviewPage> {
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();

    if (cameraStatus.isDenied || microphoneStatus.isDenied) {
      if (mounted) {
        PresentationHelper.showCustomSnackBar(
          context: context,
          message: 'Camera and Microphone permissions are required.',
          type: SnackbarType.error,
        );
        context.router.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<OnInterviewCubit>(param1: widget.questions)..initialize(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: BlocConsumer<OnInterviewCubit, OnInterviewState>(
          listener: (context, state) {
            if (state is OnInterviewFinished) {
              _showFinishedDialog(context, state);
            }

            if (state is OnInterviewError) {
              PresentationHelper.showCustomSnackBar(
                context: context,
                message: state.message,
                type: SnackbarType.error,
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  InterviewHeader(
                    currentIndex: state is OnInterviewRecording
                        ? state.currentQuestionIndex
                        : 0,
                    totalSteps: widget.questions.length,
                    sectionName: "Behavioral Section",
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          const InterviewCameraCard(),
                          if (state is OnInterviewRecording) ...[
                            const InterviewRECIndicator(),
                            const InterviewWarningIndicator(),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0.1, 0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              child: InterviewQuestionOverlay(
                                key: ValueKey(state.currentQuestionIndex),
                                question: widget
                                    .questions[state.currentQuestionIndex],
                              ),
                            ),
                          ],
                          if (state is OnInterviewCountdown)
                            InterviewCountdownOverlay(
                              count: state.validDuration,
                            ),
                          if (state is OnInterviewProcessing ||
                              state is OnInterviewLoading)
                            const Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    ),
                  ),
                  const InterviewTipsRow(),
                  if (state is OnInterviewRecording)
                    InterviewBottomSection(state: state),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showFinishedDialog(BuildContext context, OnInterviewFinished state) {
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
            onPressed: () => context.router.popUntilRoot(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
