import 'package:fluent_ui/fluent_ui.dart';
import 'package:tagdoc/core/theme/tagdoc_theme.dart';
import 'package:tagdoc/features/movies_renamer/presentation/widgets/v2/v2_buttons.dart';
import 'package:tagdoc/features/movies_renamer/presentation/widgets/v2/v2_dropdown.dart';

class ActionSidebarV2 extends StatelessWidget {
  final VoidCallback onRenameAll;
  final VoidCallback onExport;
  final VoidCallback onAddMovies;
  final VoidCallback onClearAll;
  final VoidCallback onApplyBatchChanges;

  const ActionSidebarV2({
    super.key,
    required this.onRenameAll,
    required this.onExport,
    required this.onAddMovies,
    required this.onClearAll,
    required this.onApplyBatchChanges,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Column(
        children: [
          // Batch Operations panel
          Container(
            padding: const EdgeInsets.all(24),
            decoration: TagDocDecorations.sidebarPanel,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(FluentIcons.lightning_bolt, color: TagDocColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Batch Operations',
                      style: TagDocTextStyles.sidebarHeader,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                V2GradientButton(
                  label: 'Rename All',
                  icon: FluentIcons.auto_enhance_on,
                  onPressed: onRenameAll,
                ),
                const SizedBox(height: 12),
                V2SecondaryButton(
                  label: 'Export to Excel',
                  icon: FluentIcons.document,
                  textColor: TagDocColors.primary,
                  onPressed: onExport,
                ),
                const SizedBox(height: 12),
                V2SecondaryButton(
                  label: 'Add Movies',
                  icon: FluentIcons.add_to_shopping_list,
                  textColor: TagDocColors.onSurfaceVariant,
                  onPressed: onAddMovies,
                ),
                const SizedBox(height: 16),
                const Divider(style: DividerThemeData(verticalMargin: EdgeInsets.all(0), horizontalMargin: EdgeInsets.all(0))),
                const SizedBox(height: 16),
                HoverButton(
                  onPressed: onClearAll,
                  cursor: SystemMouseCursors.click,
                  builder: (context, states) {
                    final bgColor = states.isHovered ? TagDocColors.error.withValues(alpha: 0.1) : Colors.transparent;
                    final textColor = states.isHovered ? TagDocColors.error : TagDocColors.onSurfaceVariant;
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FluentIcons.clear, color: textColor, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            'Clear All',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          
          const SizedBox(height: 24),

          // Batch Edit panel
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: TagDocColors.surfaceBright.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(FluentIcons.equalizer, color: TagDocColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Batch Edit',
                      style: TagDocTextStyles.sidebarHeader,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                V2Dropdown(
                  label: 'Resolution',
                  value: 'Select Resolution',
                  items: const ['Select Resolution', '2160p (4K)', '1080p', '720p', 'SD'],
                  onChanged: (v) {},
                ),
                const SizedBox(height: 12),
                V2Dropdown(
                  label: 'Quality',
                  value: 'Select Quality',
                  items: const ['Select Quality', 'Blu-ray', 'WEB-DL', 'Remux', 'HDTV'],
                  onChanged: (v) {},
                ),
                const SizedBox(height: 12),
                V2Dropdown(
                  label: 'Source',
                  value: 'Select Source',
                  items: const ['Select Source', 'Internal HDD', 'NAS Server', 'Cloud Storage'],
                  onChanged: (v) {},
                ),
                const SizedBox(height: 24),
                V2GradientButton(
                  label: 'Apply Changes',
                  icon: FluentIcons.accept,
                  onPressed: onApplyBatchChanges,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
