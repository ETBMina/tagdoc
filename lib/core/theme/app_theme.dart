import 'package:fluent_ui/fluent_ui.dart';

class AppTheme {
  static TextStyle labelStyle(BuildContext context) {
    final defaultCaption = FluentTheme.of(context).typography.caption;
    return defaultCaption?.copyWith(
          color: FluentTheme.of(context).resources.textFillColorTertiary,
          fontSize: 13.0,
        ) ??
        const TextStyle();
  }
}
