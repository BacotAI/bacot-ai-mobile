import 'package:flutter/widgets.dart';
import 'package:smart_interview_ai/core/widgets/option/option.dart';

class DropdownButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final List<SelectOption> options;
  final String? sheetTitle;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final bool isLoading;
  final String? initialValue;
  final bool enabled;

  const DropdownButton({
    super.key,
    required this.label,
    this.controller,
    required this.icon,
    required this.options,
    this.sheetTitle,
    this.onChanged,
    this.isLoading = false,
    this.enabled = true,
    this.initialValue,
  });

  @override
  State<DropdownButton> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<DropdownButton> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
