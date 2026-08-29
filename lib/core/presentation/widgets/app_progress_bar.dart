import 'package:fluent_ui/fluent_ui.dart';
import 'package:tagdoc/core/theme/tagdoc_theme.dart';

/// A reusable progress bar widget for displaying task completion and loading status.
///
/// Designed to follow TagDoc design language and Fluent UI guidelines.
/// Dynamically calculates progress percentage and smoothly spans the full width
/// of the container, reaching 100% flush with the edges when complete.
class AppProgressBar extends StatelessWidget {
  /// The current completed units of work (e.g., number of processed files).
  final int? current;

  /// The total units of work to complete.
  final int? total;

  /// The header title displayed above the progress bar.
  final String title;

  /// An optional descriptive message or file name displayed below the progress bar.
  final String? statusMessage;

  /// The thickness / height of the progress track.
  final double strokeWidth;

  /// Creates an [AppProgressBar].
  const AppProgressBar({
    super.key,
    this.current,
    this.total,
    this.title = 'Processing...',
    this.statusMessage,
    this.strokeWidth = 4.5,
  });

  /// Computes progress as a normalized ratio between `0.0` and `1.0`.
  ///
  /// Returns `null` if [total] is null or <= 0, allowing indeterminate mode.
  double? get progress {
    if (total == null || total! <= 0 || current == null) {
      return null;
    }
    return (current! / total!).clamp(0.0, 1.0);
  }

  /// Computes percentage value between `0.0` and `100.0`.
  double? get percentageValue => progress != null ? progress! * 100.0 : null;

  /// Formatted percentage string (e.g., "45%").
  String? get percentageString {
    final val = percentageValue;
    return val != null ? '${val.toInt()}%' : null;
  }

  @override
  Widget build(BuildContext context) {
    final countText = (current != null && total != null && total! > 0)
        ? '$current / $total'
        : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: TagDocColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: TagDocColors.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row with title, count, and percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    FluentIcons.processing,
                    size: 16,
                    color: TagDocColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: TagDocColors.onSurface,
                    ),
                  ),
                ],
              ),
              if (countText != null || percentageString != null)
                Text(
                  [
                    if (countText != null) countText,
                    if (percentageString != null) '($percentageString)',
                  ].join(' '),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: TagDocColors.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          // Full-width progress track with exact 100% alignment
          LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = constraints.maxWidth;

              if (progress == null) {
                return SizedBox(
                  width: double.infinity,
                  child: ProgressBar(strokeWidth: strokeWidth),
                );
              }

              final activeWidth = (trackWidth * progress!).clamp(
                0.0,
                trackWidth,
              );

              return ClipRRect(
                borderRadius: BorderRadius.circular(strokeWidth / 2),
                child: Stack(
                  children: [
                    // Background track
                    Container(
                      height: strokeWidth,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: TagDocColors.surfaceBright,
                        borderRadius: BorderRadius.circular(strokeWidth / 2),
                      ),
                    ),
                    // Active animated fill
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOutCubic,
                      height: strokeWidth,
                      width: activeWidth,
                      decoration: BoxDecoration(
                        color: TagDocColors.primary,
                        borderRadius: BorderRadius.circular(strokeWidth / 2),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (statusMessage != null && statusMessage!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              statusMessage!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TagDocTextStyles.codeFilename,
            ),
          ],
        ],
      ),
    );
  }
}
