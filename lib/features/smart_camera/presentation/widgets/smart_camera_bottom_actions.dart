import 'package:flutter/material.dart';

enum CameraMode { pose, face, object }

class SmartCameraBottomActions extends StatelessWidget {
  final CameraMode mode;
  final ValueChanged<CameraMode> onModeChanged;

  const SmartCameraBottomActions({
    super.key,
    required this.mode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: _buildStatusIndicator(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildModeButton(CameraMode.pose, "Pose"),
            const SizedBox(width: 16),
            _buildModeButton(CameraMode.face, "Face"),
            const SizedBox(width: 16),
            _buildModeButton(CameraMode.object, "Object"),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.info_outline, color: Colors.white, size: 20),
        SizedBox(width: 8),
        Text("Testing AI camera", style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildModeButton(CameraMode itemMode, String label) {
    final isSelected = mode == itemMode;
    return GestureDetector(
      onTap: () => onModeChanged(itemMode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent
              : Colors.grey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
