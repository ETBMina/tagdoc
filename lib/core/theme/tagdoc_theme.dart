import 'package:flutter/widgets.dart';

class TagDocColors {
  static const Color surfaceBright = Color(0xFF31394d);
  static const Color outlineVariant = Color(0xFF414754);
  static const Color background = Color(0xFF0b1326);
  static const Color surfaceContainerLowest = Color(0xFF060e20);
  static const Color surfaceContainerLow = Color(0xFF131b2e);
  static const Color primary = Color(0xFFaac7ff);
  static const Color primaryContainer = Color(0xFF3e90ff);
  static const Color surfaceVariant = Color(0xFF2d3449);
  static const Color onBackground = Color(0xFFdae2fd);
  static const Color outline = Color(0xFF8b91a0);
  static const Color onSurfaceVariant = Color(0xFFc0c6d6);
  static const Color surfaceContainer = Color(0xFF171f33);
  static const Color surfaceContainerHigh = Color(0xFF222a3d);
  static const Color surfaceContainerHighest = Color(0xFF2d3449);
  static const Color error = Color(0xFFffb4ab);
  static const Color onPrimary = Color(0xFF003064);
  static const Color onPrimaryContainer = Color(0xFF002957);
  static const Color surface = Color(0xFF0b1326);
  static const Color onSurface = Color(0xFFdae2fd);
}

class TagDocTextStyles {
  static const TextStyle headline = TextStyle(
    fontFamily: 'Manrope',
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.normal,
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle fieldLabel = TextStyle(
    fontFamily: 'Inter',
    color: TagDocColors.onSurfaceVariant,
    fontSize: 9,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static const TextStyle fieldValue = TextStyle(
    fontFamily: 'Inter',
    color: TagDocColors.onSurface,
    fontSize: 12,
  );

  static const TextStyle pillLabel = TextStyle(
    fontFamily: 'Inter',
    color: TagDocColors.primary,
    fontSize: 8,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );

  static final TextStyle codeFilename = TextStyle(
    color: TagDocColors.onSurfaceVariant.withValues(alpha: 0.6),
    fontSize: 10,
    fontFamily: 'Consolas',
    fontFamilyFallback: const ['Courier New', 'monospace'],
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: 'Inter',
    color: TagDocColors.onSurface,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle sidebarHeader = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: TagDocColors.onSurface,
  );

  static const TextStyle primaryButton = TextStyle(
    color: TagDocColors.onPrimaryContainer,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    fontFamily: 'Manrope',
  );

  static const TextStyle secondaryButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    fontFamily: 'Manrope',
  );
}

class TagDocDecorations {
  static final BoxDecoration fieldDecoration = BoxDecoration(
    color: TagDocColors.surfaceContainerLowest,
    borderRadius: BorderRadius.circular(4),
  );

  static final BoxDecoration sidebarPanel = BoxDecoration(
    color: TagDocColors.surfaceContainerHigh,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: TagDocColors.outlineVariant.withValues(alpha: 0.1),
    ),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF000000).withValues(alpha: 0.25),
        blurRadius: 24,
        offset: const Offset(0, 10),
      ),
    ],
  );

  static final BoxDecoration primaryButton = BoxDecoration(
    gradient: const LinearGradient(
      colors: [TagDocColors.primary, TagDocColors.primaryContainer],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: TagDocColors.primary.withValues(alpha: 0.2),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static final BoxDecoration secondaryButton = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: TagDocColors.outlineVariant.withValues(alpha: 0.2),
    ),
  );
}
