import 'package:fluent_ui/fluent_ui.dart';

/// Provides reusable overlay helpers for non-blocking UI notifications.
class OverlayUtils {
  OverlayUtils._();

  /// Shows a generic [InfoBar] overlay notification.
  ///
  /// - [title]: The bold title of the bar.
  /// - [message]: The descriptive content.
  /// - [severity]: Controls the icon and color of the bar. Defaults to [InfoBarSeverity.info].
  /// - [duration]: How long the bar stays visible. Defaults to 4 seconds.
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    InfoBarSeverity severity = InfoBarSeverity.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    displayInfoBar(
      context,
      duration: duration,
      builder: (context, close) {
        return InfoBar(
          title: Text(title),
          content: Text(message),
          severity: severity,
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
        );
      },
    );
  }

  /// Shorthand for showing a success [InfoBar].
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      title: 'Success',
      message: message,
      severity: InfoBarSeverity.success,
      duration: duration,
    );
  }

  /// Shorthand for showing an error [InfoBar].
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 5),
  }) {
    show(
      context,
      title: 'Error',
      message: message,
      severity: InfoBarSeverity.error,
      duration: duration,
    );
  }

  /// Shorthand for showing a warning [InfoBar].
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      title: 'Warning',
      message: message,
      severity: InfoBarSeverity.warning,
      duration: duration,
    );
  }
}
