import 'package:fluent_ui/fluent_ui.dart';
import 'package:tagdoc/core/theme/tagdoc_theme.dart';

/// A standardized scaffold wrapper for pages in the TagDoc application.
///
/// This widget provides consistent layout structure, including the page background
/// color, global page padding, and the standardized page title layout.
///
/// It follows the composition over inheritance model, where page-specific
/// components (like rows, columns, lists, and sidebars) are passed as the [child] parameter.
class AppPageScaffold extends StatelessWidget {
  /// The title of the page, displayed at the top of the content area.
  final String title;

  /// The main content of the page, placed below the page title.
  final Widget child;

  /// Creates an [AppPageScaffold] with the given [title] and [child] content.
  const AppPageScaffold({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Container(
        color: TagDocColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Standardized page title header
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: TagDocColors.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),
              // Main content body
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
