import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_interview_ai/application/on_interview/on_interview_bloc.dart';
import 'interview_waveform.dart';
import 'interview_controls.dart';

class InterviewBottomSection extends StatelessWidget {
  final OnInterviewState state;

  const InterviewBottomSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    int remainingSeconds = 0;
    double audioLevel = 0.0;

    if (state is OnInterviewRecording) {
      final s = state as OnInterviewRecording;
      remainingSeconds = s.remainingSeconds;
      audioLevel = s.audioLevel;
    } else if (state is OnInterviewStepTransition) {
      final s = state as OnInterviewStepTransition;
      remainingSeconds = 0;
      audioLevel = s.audioLevel;
    } else if (state is OnInterviewCountdown) {
      remainingSeconds = 0;
      audioLevel = 0.0;
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Timer
              Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDuration(remainingSeconds),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      fontFamily: 'Monospace',
                    ),
                  ),
                ],
              ),

              // Waveform
              InterviewWaveform(audioLevel: audioLevel),

              // Mic Status
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F7FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.circle, color: Colors.green, size: 8),
                    SizedBox(width: 6),
                    Text(
                      "MIC ON",
                      style: TextStyle(
                        color: Color(0xFF0088CC),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        InterviewControls(
          canGoNext: true, // Allow manual stop
          onSkip: () =>
              context.read<OnInterviewBloc>().add(const OnInterviewStopped()),
          onNext: () =>
              context.read<OnInterviewBloc>().add(const OnInterviewStopped()),
        ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
