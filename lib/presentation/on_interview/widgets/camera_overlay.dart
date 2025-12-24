import 'package:flutter/material.dart';
import 'package:smart_interview_ai/domain/on_interview/entities/scoring_result.dart';
import 'audio_waveform.dart';

class InterviewOverlay extends StatelessWidget {
  final String questionText;
  final int? countdown;
  final int? elapsedSeconds;
  final ScoringResult? feedback;
  final VoidCallback? onStopPressed;

  const InterviewOverlay({
    super.key,
    required this.questionText,
    this.countdown,
    this.elapsedSeconds,
    this.feedback,
    this.onStopPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Question Top Overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Text(
                  questionText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                ),
                const SizedBox(height: 16),
                if (elapsedSeconds != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.circle, color: Colors.red, size: 12),
                        const SizedBox(width: 8),
                        Text(
                          _formatDuration(elapsedSeconds!),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const AudioWaveform(isAnimating: true),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Countdown
        if (countdown != null && countdown! > 0)
          Center(
            child: Text(
              '$countdown',
              style: const TextStyle(
                fontSize: 120,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 20, color: Colors.black)],
              ),
            ),
          ),

        // Feedback Toast
        if (feedback != null && feedback!.feedbackMessage.isNotEmpty)
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      feedback!.feedbackMessage,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Bottom Actions
        if (onStopPressed != null)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton.extended(
                onPressed: onStopPressed,
                backgroundColor: Colors.red,
                icon: const Icon(Icons.stop_rounded),
                label: const Text("Selesai & Analisis"),
              ),
            ),
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
