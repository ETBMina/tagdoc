import 'package:fluent_ui/fluent_ui.dart';
import 'package:tagdoc/core/theme/tagdoc_theme.dart';

class V2TextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const V2TextField({
    super.key,
    required this.label,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TagDocTextStyles.fieldLabel,
        ),
        const SizedBox(height: 2),
        SizedBox(
          height: 28,
          child: TextBox(
            controller: controller,
            onChanged: onChanged,
            style: TagDocTextStyles.fieldValue,
            decoration: WidgetStateProperty.all(
              TagDocDecorations.fieldDecoration.copyWith(
                border: Border.all(color: Colors.transparent),
              ),
            ),
            highlightColor: TagDocColors.primary.withValues(alpha: 0.4),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          ),
        ),
      ],
    );
  }
}
