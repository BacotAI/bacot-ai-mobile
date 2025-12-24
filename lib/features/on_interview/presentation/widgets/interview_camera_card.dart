import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_interview_ai/app/di.dart';
import 'package:smart_interview_ai/core/services/interview_recorder_service.dart';
import '../cubit/on_interview_cubit.dart';
import '../cubit/on_interview_state.dart';

class InterviewCameraCard extends StatelessWidget {
  const InterviewCameraCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnInterviewCubit, OnInterviewState>(
      builder: (context, state) {
        final recorder = sl<InterviewRecorderService>();
        final controller = recorder.cameraController;

        final bool isTerminal =
            state is OnInterviewFinished ||
            state is OnInterviewError ||
            state is OnInterviewInitial;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
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
                : Container(color: Colors.black),
          ),
        );
      },
    );
  }
}
