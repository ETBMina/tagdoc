import 'package:fluent_ui/fluent_ui.dart';

import 'package:tagdoc/core/theme/app_theme.dart';

class CardTextBoxWdgt extends StatelessWidget {
  final TextEditingController controller;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final String title;

  const CardTextBoxWdgt({
    super.key,
    required this.controller,
    this.placeholder,
    this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InfoLabel(
      label: title,
      labelStyle: AppTheme.labelStyle(context),
      child: TextBox(
        controller: controller,
        placeholder: placeholder,
        onChanged: onChanged,
      ),
    );
  }
}
