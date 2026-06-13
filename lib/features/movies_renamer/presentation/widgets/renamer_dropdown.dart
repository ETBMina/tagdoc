import 'package:fluent_ui/fluent_ui.dart';
import 'package:tagdoc/core/theme/tagdoc_theme.dart';

class RenamerDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const RenamerDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: TagDocTextStyles.fieldLabel),
        const SizedBox(height: 2),
        SizedBox(
          height: 28, // Matches text field height roughly
          child: Container(
            decoration: TagDocDecorations.fieldDecoration,
            child: ComboBox<String>(
              value: value,
              items: items.map((e) {
                return ComboBoxItem(
                  value: e,
                  child: Text(e, style: TagDocTextStyles.fieldValue),
                );
              }).toList(),
              onChanged: onChanged,
              isExpanded: true,
              iconEnabledColor: TagDocColors.onSurfaceVariant,
              style: TagDocTextStyles.fieldValue,
            ),
          ),
        ),
      ],
    );
  }
}
