import 'package:flutter/material.dart';
import 'package:smart_interview_ai/core/widgets/snackbar/custom_snackbar.dart';

class PresentationHelper {
  static OverlayEntry? _currentOverlayEntry;

  static void showCustomSnackBar({
    required BuildContext context,
    required String message,
    required SnackbarType type,
  }) {
    _removeCurrentSnackBar();

    final overlay = Overlay.of(context);

    _currentOverlayEntry = OverlayEntry(
      builder: (context) => TopSnackbar(
        message: message,
        type: type,
        onDismiss: _removeCurrentSnackBar,
      ),
    );

    overlay.insert(_currentOverlayEntry!);
  }

  static void _removeCurrentSnackBar() {
    if (_currentOverlayEntry != null) {
      _currentOverlayEntry!.remove();
      _currentOverlayEntry = null;
    }
  }

  static void showImmediateSnackBar(BuildContext context, SnackBar snackBar) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
