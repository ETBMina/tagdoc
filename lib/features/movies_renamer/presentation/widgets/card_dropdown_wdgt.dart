import 'package:fluent_ui/fluent_ui.dart';

import 'package:tagdoc/core/theme/app_theme.dart';

class CardDropdownWdgt extends StatelessWidget {
  final List<String> items;
  final String value;
  final ValueChanged<String?> onChanged;
  final String title;

  const CardDropdownWdgt({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InfoLabel(
      label: title,
      labelStyle: AppTheme.labelStyle(context),
      child: ComboBox<String>(
        value: value,
        items: items.map((item) {
          return ComboBoxItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
