import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/application/on_interview/on_interview_bloc.dart';
import 'package:smart_interview_ai/core/helper/presentation_helper.dart';
import 'package:smart_interview_ai/core/widgets/snackbar/custom_snackbar.dart';
import 'package:smart_interview_ai/domain/pre_interview/entities/question_entity.dart';
import 'package:smart_interview_ai/presentation/on_interview/widgets/interview_bottom_section.dart';
import 'package:smart_interview_ai/presentation/on_interview/widgets/interview_camera_card.dart';
import 'package:smart_interview_ai/presentation/on_interview/widgets/interview_countdown_overlay.dart';
import 'package:smart_interview_ai/presentation/on_interview/widgets/interview_header.dart';
import 'package:smart_interview_ai/presentation/on_interview/widgets/interview_indicators.dart';
import 'package:smart_interview_ai/presentation/on_interview/widgets/interview_question_overlay.dart';
import 'package:smart_interview_ai/presentation/on_interview/widgets/interview_tips_row.dart';
import 'package:smart_interview_ai/presentation/on_interview/widgets/interview_processing_view.dart';
import 'package:smart_interview_ai/presentation/on_interview/widgets/interview_transcription_indicator.dart';
import 'package:smart_interview_ai/presentation/on_interview/widgets/interview_finished_dialog.dart';

@RoutePage()
class OnInterviewPage extends StatefulWidget {
  final List<QuestionEntity> questions;

  const OnInterviewPage({super.key, required this.questions});

  @override
  State<OnInterviewPage> createState() => _OnInterviewPageState();
}

class _OnInterviewPageState extends State<OnInterviewPage> {
  bool _dialogShown = false;

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

  void _showFinishedDialog(BuildContext context, OnInterviewFinished state) {
    if (_dialogShown) return;
    _dialogShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => InterviewFinishedDialog(
        initialState: state,
        questions: widget.questions,
        bloc: context.read<OnInterviewBloc>(),
      ),
    ).then((_) => _dialogShown = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<OnInterviewBloc>()
            ..add(OnInterviewInitialized(questions: widget.questions)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: BlocConsumer<OnInterviewBloc, OnInterviewState>(
          listener: (context, state) {
            if (state is OnInterviewFinished) {
              PresentationHelper.showCustomSnackBar(
                context: context,
                message:
                    'All ${state.videoPaths.length} interview recordings have been saved successfully to your local storage.',
                type: SnackbarType.success,
              );
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
            if (state is OnInterviewProcessing) {
              return SafeArea(child: const InterviewProcessingView());
            }

            return SafeArea(
              child: Column(
                children: [
                  InterviewHeader(
                    currentIndex: state is OnInterviewRecording
                        ? state.currentQuestionIndex
                        : (state is OnInterviewStepTransition
                              ? (state).toIndex
                              : 0),
                    totalSteps: widget.questions.length,
                    sectionName: "Behavioral Section",
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          const InterviewCameraCard(),

                          if (state is OnInterviewRecording ||
                              state is OnInterviewCountdown)
                            Positioned(
                              bottom: state is OnInterviewRecording
                                  ? MediaQuery.of(context).size.height * 0.18
                                  : 20,
                              left: 20,
                              right: 20,
                              child: Center(child: InterviewTipsRow()),
                            ),

                          if (state is OnInterviewRecording ||
                              state is OnInterviewStepTransition) ...[
                            const InterviewRECIndicator(),

                            // TODO: const InterviewWarningIndicator(),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              right: 20,
                              child: AnimatedSwitcher(
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
                                  key: ValueKey(
                                    state is OnInterviewRecording
                                        ? state.currentQuestionIndex
                                        : (state as OnInterviewStepTransition)
                                              .toIndex,
                                  ),
                                  question:
                                      widget.questions[state
                                              is OnInterviewRecording
                                          ? state.currentQuestionIndex
                                          : (state as OnInterviewStepTransition)
                                                .toIndex],
                                ),
                              ),
                            ),
                          ],

                          if (state is OnInterviewCountdown)
                            InterviewCountdownOverlay(
                              count: state.validDuration,
                            ),

                          if (state is OnInterviewLoading)
                            const Center(child: CircularProgressIndicator()),

                          if (state is OnInterviewRecording)
                            InterviewTranscriptionIndicator(
                              transcriptionStatuses:
                                  state.transcriptionStatuses,
                            ),

                          if (state is OnInterviewStepTransition)
                            InterviewTranscriptionIndicator(
                              transcriptionStatuses:
                                  state.transcriptionStatuses,
                            ),
                        ],
                      ),
                    ),
                  ),

                  if (state is OnInterviewRecording ||
                      state is OnInterviewStepTransition ||
                      state is OnInterviewCountdown)
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
}
