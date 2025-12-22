import 'package:flutter/material.dart';

class SelectOption {
  final String key;
  final String label;
  final OptionRichLabel? richLabel;
  final bool selected;
  final bool? disable;
  final bool? disableHelperWidget;
  final Widget? suffix;

  const SelectOption({
    required this.key,
    required this.label,
    this.richLabel,
    this.selected = false,
    this.disable,
    this.disableHelperWidget,
    this.suffix,
  });

  SelectOption copyWith({
    String? key,
    String? label,
    OptionRichLabel? richLabel,
    bool? selected,
    bool? disable,
    bool? disableHelperWidget,
    Widget? suffix,
  }) {
    return SelectOption(
      key: key ?? this.key,
      label: label ?? this.label,
      richLabel: richLabel ?? this.richLabel,
      selected: selected ?? this.selected,
      disable: disable ?? this.disable,
      disableHelperWidget: disableHelperWidget ?? this.disableHelperWidget,
      suffix: suffix ?? this.suffix,
    );
  }

  factory SelectOption.empty() =>
      const SelectOption(key: '', label: '', selected: false);
}

class OptionRichLabel {
  final String title;
  final String subtitle;

  OptionRichLabel({required this.title, required this.subtitle});
}
