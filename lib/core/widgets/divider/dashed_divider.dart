import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  final double dashWidth;
  final double dashHeight;
  final Color color;
  final EdgeInsetsGeometry? margin;

  const DashedDivider({
    super.key,
    this.dashWidth = 4.0,
    this.dashHeight = 1.0,
    this.color = const Color(0xFFE2E8F0),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    Widget divider = LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );

    if (margin != null) {
      divider = Padding(padding: margin!, child: divider);
    }

    return divider;
  }
}
