import 'package:flutter/material.dart';

class VideoControlActions extends StatelessWidget {
  final bool isRecording;
  final bool isProcessing;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;

  const VideoControlActions({
    super.key,
    required this.isRecording,
    required this.isProcessing,
    required this.onStartRecording,
    required this.onStopRecording,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: isProcessing
                ? null
                : (isRecording ? onStopRecording : onStartRecording),
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isRecording ? Colors.redAccent : Colors.white,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: (isRecording ? Colors.redAccent : Colors.white)
                        .withValues(alpha: 0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: isProcessing
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : Icon(
                      isRecording
                          ? Icons.stop_rounded
                          : Icons.fiber_manual_record_rounded,
                      color: isRecording ? Colors.white : Colors.red,
                      size: 40,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
