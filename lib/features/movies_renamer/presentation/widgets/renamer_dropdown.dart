import 'package:fluent_ui/fluent_ui.dart';
import 'package:tagdoc/core/theme/tagdoc_theme.dart';

/// A dropdown field used in movie card rows.
///
/// Caches the [ComboBoxItem] list built from [items] to avoid repeated
/// `.map().toList()` allocations on every build during scrolling.
class RenamerDropdown extends StatefulWidget {
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
  State<RenamerDropdown> createState() => _RenamerDropdownState();
}

class _RenamerDropdownState extends State<RenamerDropdown> {
  late String _uppercasedLabel;
  late List<ComboBoxItem<String>> _comboBoxItems;

  @override
  void initState() {
    super.initState();
    _uppercasedLabel = widget.label.toUpperCase();
    _comboBoxItems = _buildItems(widget.items);
  }

  @override
  void didUpdateWidget(RenamerDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.items, widget.items)) {
      _comboBoxItems = _buildItems(widget.items);
    }
    if (oldWidget.label != widget.label) {
      _uppercasedLabel = widget.label.toUpperCase();
    }
  }

  List<ComboBoxItem<String>> _buildItems(List<String> items) {
    return items.map((e) {
      return ComboBoxItem(
        value: e,
        child: Text(e, style: TagDocTextStyles.fieldValue),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_uppercasedLabel, style: TagDocTextStyles.fieldLabel),
        const SizedBox(height: 2),
        SizedBox(
          height: 28,
          child: Container(
            decoration: TagDocDecorations.fieldDecoration,
            child: ComboBox<String>(
              value: widget.value,
              items: _comboBoxItems,
              onChanged: widget.onChanged,
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
