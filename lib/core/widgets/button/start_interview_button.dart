import 'package:flutter/material.dart';

class StartInterviewButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final bool isDisabled;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final double borderRadius;

  const StartInterviewButton({
    super.key,
    required this.label,
    this.onTap,
    this.leftIcon,
    this.rightIcon,
    this.isDisabled = false,
    this.backgroundColor = const Color(0xFF0F172A),
    this.textColor = Colors.white,
    this.height = 64,
    this.borderRadius = 100,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = isDisabled
        ? Colors.grey.shade300
        : backgroundColor;

    final effectiveTextColor = isDisabled ? Colors.grey.shade500 : textColor;

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: (backgroundColor ?? const Color(0xFF0F172A)).withAlpha(
                    50,
                  ),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                if (leftIcon != null)
                  Icon(leftIcon, color: effectiveTextColor, size: 20),
                const Spacer(),
                Text(
                  label,
                  style: TextStyle(
                    color: effectiveTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                if (rightIcon != null)
                  Icon(rightIcon, color: effectiveTextColor, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
