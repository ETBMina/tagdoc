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
  final VoidCallback onPressed;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.icon,
    this.textColor = TagDocColors.primary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: onPressed,
      cursor: SystemMouseCursors.click,
      builder: (context, states) {
        final bgColor = states.isHovered
            ? TagDocColors.surfaceBright
            : TagDocColors.surfaceContainerHighest;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: TagDocDecorations.secondaryButton.copyWith(
            color: bgColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: TagDocTextStyles.secondaryButton.copyWith(
                  color: textColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
