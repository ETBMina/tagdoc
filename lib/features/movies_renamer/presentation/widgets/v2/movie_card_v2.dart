import 'package:fluent_ui/fluent_ui.dart';
import 'package:tagdoc/core/theme/tagdoc_theme.dart';
import 'package:tagdoc/features/movies_renamer/presentation/widgets/v2/v2_dropdown.dart';
import 'package:tagdoc/features/movies_renamer/presentation/widgets/v2/v2_text_field.dart';

class MovieCardV2 extends StatefulWidget {
  final String fileName;
  final String title;
  final String year;
  final String resolution;
  final String quality;
  final String source;
  final String? poster;

  const MovieCardV2({
    super.key,
    required this.fileName,
    required this.title,
    required this.year,
    required this.resolution,
    required this.quality,
    required this.source,
    this.poster,
  });

  @override
  State<MovieCardV2> createState() => _MovieCardV2State();
}

class _MovieCardV2State extends State<MovieCardV2> {
  late TextEditingController _titleController;
  late TextEditingController _yearController;
  late String _resolution;
  late String _quality;
  late String _source;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _yearController = TextEditingController(text: widget.year);
    _resolution = widget.resolution;
    _quality = widget.quality;
    _source = widget.source;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: _isSelected ? TagDocColors.surfaceContainer : TagDocColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isSelected ? TagDocColors.primary.withValues(alpha: 0.3) : TagDocColors.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      child: Stack(
        children: [
          if (_isSelected)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: 2,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: TagDocColors.primary,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Checkbox(
                  checked: _isSelected,
                  onChanged: (val) {
                    setState(() {
                      _isSelected = val ?? false;
                    });
                  },
                ),
                const SizedBox(width: 16),
                Container(
                  width: 64,
                  height: 96,
                  decoration: BoxDecoration(
                    color: TagDocColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: widget.poster != null
                      ? Image.network(widget.poster!, fit: BoxFit.cover)
                      : const Center(
                          child: Icon(FluentIcons.my_movies_t_v, size: 24, color: TagDocColors.onSurfaceVariant),
                        ),
                ),
                const SizedBox(width: 16),
                // Meta fields
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: TagDocColors.primary.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'ORIGINAL',
                                        style: TagDocTextStyles.pillLabel,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        widget.fileName,
                                        style: TagDocTextStyles.codeFilename,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                TextBox(
                                  controller: _titleController,
                                  style: TagDocTextStyles.cardTitle,
                                  decoration: WidgetStateProperty.all(const BoxDecoration(
                                    border: Border(), // No border
                                    color: Colors.transparent,
                                  )),
                                  padding: const EdgeInsets.all(0),
                                  highlightColor: TagDocColors.surfaceContainerHigh,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(FluentIcons.delete, color: TagDocColors.onSurfaceVariant),
                            onPressed: () {
                              // Handle delete (would communicate back via callback or BLoC)
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: V2TextField(
                              label: 'Release',
                              controller: _yearController,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: V2Dropdown(
                              label: 'Resolution',
                              value: _resolution,
                              items: const ['2160p (4K)', '1080p', '720p', 'SD'],
                              onChanged: (v) {
                                if (v != null) setState(() => _resolution = v);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: V2Dropdown(
                              label: 'Quality',
                              value: _quality,
                              items: const ['Blu-ray', 'WEB-DL', 'Remux', 'HDTV'],
                              onChanged: (v) {
                                if (v != null) setState(() => _quality = v);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: V2Dropdown(
                              label: 'Source',
                              value: _source,
                              items: const ['Netflix', 'Amazon Prime', 'Disney+', 'Hulu', 'Apple TV+', 'None'],
                              onChanged: (v) {
                                if (v != null) setState(() => _source = v);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
