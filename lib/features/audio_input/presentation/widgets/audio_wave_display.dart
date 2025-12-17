import 'dart:ui' as ui;

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

class AudioWaveformDisplay extends StatelessWidget {
  final RecorderController recorderController;

  const AudioWaveformDisplay({super.key, required this.recorderController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Center(
        child: AudioWaveforms(
          size: Size(MediaQuery.of(context).size.width - 64, 100),
          recorderController: recorderController,
          enableGesture: true,
          waveStyle: WaveStyle(
            waveColor: theme.colorScheme.secondary,
            spacing: 6.0,
            showBottom: true,
            extendWaveform: true,
            showMiddleLine: false,
            waveCap: StrokeCap.round,
            waveThickness: 4.0,
            scaleFactor: 120.0, // Increased for more dramatic wave motion
            gradient: ui.Gradient.linear(
              const Offset(0, 0),
              Offset(MediaQuery.of(context).size.width, 0),
              [theme.colorScheme.primary, theme.colorScheme.secondary],
            ),
          ),
        ),
      ),
    );
  }
}
