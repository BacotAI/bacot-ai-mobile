import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smart_interview_ai/domain/transcription/entities/transcription_status.dart';

class InterviewTranscriptionIndicator extends StatelessWidget {
  final Map<int, TranscriptionStatus> transcriptionStatuses;

  const InterviewTranscriptionIndicator({
    super.key,
    required this.transcriptionStatuses,
  });

  @override
  Widget build(BuildContext context) {
    final processingCount = transcriptionStatuses.values
        .where((status) => status == TranscriptionStatus.processing)
        .length;

    if (processingCount == 0) return const SizedBox.shrink();

    return Positioned(
      top: 20,
      left: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withAlpha(100),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withAlpha(30)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Transcribing ($processingCount)...",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
