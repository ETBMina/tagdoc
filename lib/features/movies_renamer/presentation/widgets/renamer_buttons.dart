import 'package:fluent_ui/fluent_ui.dart';
import 'package:tagdoc/core/theme/tagdoc_theme.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: onPressed,
      cursor: SystemMouseCursors.click,
      builder: (context, states) {
        final double scale = states.isPressed
            ? 0.98
            : (states.isHovered ? 1.02 : 1.0);

        return Transform.scale(
          scale: scale,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: TagDocDecorations.primaryButton,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: TagDocColors.onPrimaryContainer, size: 20),
                const SizedBox(width: 12),
                Text(label, style: TagDocTextStyles.primaryButton),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color textColor;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.icon,
    this.textColor = TagDocColors.primary,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    return HoverButton(
      onPressed: effectiveOnPressed,
      cursor: effectiveOnPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      builder: (context, states) {
        final isEnabled = effectiveOnPressed != null;
        final bgColor = !isEnabled
            ? TagDocColors.surfaceContainerHigh.withValues(alpha: 0.5)
            : (states.isHovered
                  ? TagDocColors.surfaceBright
                  : TagDocColors.surfaceContainerHighest);

        final currentTextColor = !isEnabled
            ? TagDocColors.onSurfaceVariant.withValues(alpha: 0.4)
            : textColor;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: TagDocDecorations.secondaryButton.copyWith(
            color: bgColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: ProgressRing(strokeWidth: 2.5),
                ),
                const SizedBox(width: 12),
              ] else ...[
                Icon(icon, color: currentTextColor, size: 20),
                const SizedBox(width: 12),
              ],
              Text(
                label,
                style: TagDocTextStyles.secondaryButton.copyWith(
                  color: currentTextColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
