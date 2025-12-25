import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/application/on_interview/on_interview_bloc.dart';
import 'package:smart_interview_ai/core/services/interview_recorder_service.dart';

class InterviewCameraCard extends StatelessWidget {
  const InterviewCameraCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnInterviewBloc, OnInterviewState>(
      builder: (context, state) {
        final recorder = sl<InterviewRecorderService>();
        final controller = recorder.cameraController;

        final bool isTerminal =
            state is OnInterviewFinished ||
            state is OnInterviewError ||
            state is OnInterviewInitial ||
            state is OnInterviewProcessing;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 30,
                spreadRadius: -5,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child:
                controller != null &&
                    controller.value.isInitialized &&
                    !isTerminal
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller.value.previewSize?.height,
                      height: controller.value.previewSize?.width,
                      child: CameraPreview(controller),
                    ),
                  )
                : Container(
                    color: const Color(0xFF0F172A),
                    child: const Center(
                      child: Icon(
                        Icons.videocam_off_rounded,
                        color: Colors.white24,
                        size: 48,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
