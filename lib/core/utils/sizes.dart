import 'package:flutter/material.dart';

class SizesApp {
  static const double margin = 16;
  static const double borderRadiusV2 = 6;
  static const double borderRadius = 8;
  static const double maxImageWidth = 320;
  static const double maxImageHeight = 120;
  static const double maxColWidth = 600;

  static double safeAreaHeight(BuildContext context) {
    return MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
  }
}
