import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class VideoPreviewWidget extends StatelessWidget {
  final CameraController? controller;

  const VideoPreviewWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        var scale = size.aspectRatio * controller!.value.aspectRatio;

        if (scale < 1) scale = 1 / scale;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Transform.scale(
                  scale: scale,
                  child: Center(child: CameraPreview(controller!)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
