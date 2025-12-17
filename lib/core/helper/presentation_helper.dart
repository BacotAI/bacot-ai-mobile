import 'package:flutter/material.dart';

class PresentationHelper {
  static void showImmediateSnackBar(BuildContext context, SnackBar snackBar) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
