import 'package:fluent_ui/fluent_ui.dart';
import 'package:tagdoc/core/theme/tagdoc_theme.dart';

/// Provides reusable dialog helpers for common UI interactions.
class DialogUtils {
  DialogUtils._();

  /// Shows a generic confirmation dialog with a cancel and a confirm button.
  ///
  /// - [title]: The dialog title (e.g., 'Clear All Movies').
  /// - [content]: The descriptive message for the user.
  /// - [confirmText]: The label of the destructive confirm button.
  /// - [onConfirm]: The callback executed when the user confirms.
  /// - [confirmButtonColor]: Optional color for the confirm button. Defaults to [TagDocColors.error].
  static Future<void> showConfirmation({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required VoidCallback onConfirm,
    Color? confirmButtonColor,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return ContentDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            Button(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  confirmButtonColor ?? TagDocColors.error,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}
