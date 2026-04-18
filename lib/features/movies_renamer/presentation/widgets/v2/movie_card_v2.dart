import 'package:fluent_ui/fluent_ui.dart';
import 'package:tagdoc/core/config/settings_manager.dart';
import 'package:tagdoc/core/theme/tagdoc_theme.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie.dart';
import 'package:tagdoc/features/movies_renamer/presentation/widgets/v2/v2_dropdown.dart';
import 'package:tagdoc/features/movies_renamer/presentation/widgets/v2/v2_text_field.dart';

class MovieCardV2 extends StatefulWidget {
  final Movie movie;
  final Function(Movie updatedMovie) onUpdateMovie;

  const MovieCardV2({
    super.key,
    required this.movie,
    required this.onUpdateMovie,
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
    final metadata = widget.movie.metadata;
    _titleController = TextEditingController(
      text: metadata?.title ?? widget.movie.fileName,
    );

    String year = '';
    if (metadata != null && metadata.releaseDate.isNotEmpty) {
      year = metadata.releaseDate.split('-').first;
    }
    _yearController = TextEditingController(text: year);

    _resolution = widget.movie.getResolutionString();
    _quality = widget.movie.quality;
    _source = widget.movie.source ?? 'None';
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
        color: _isSelected
            ? TagDocColors.surfaceContainer
            : TagDocColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isSelected
              ? TagDocColors.primary.withValues(alpha: 0.3)
              : TagDocColors.outlineVariant.withValues(alpha: 0.1),
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
                  // Poster Placeholder (Actual posters would come from metadata or local cache)
                  child: const Center(
                    child: Icon(
                      FluentIcons.my_movies_t_v,
                      size: 24,
                      color: TagDocColors.onSurfaceVariant,
                    ),
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: TagDocColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'FILENAME',
                                        style: TagDocTextStyles.pillLabel,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        widget.movie.fileName,
                                        style: TagDocTextStyles.codeFilename,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Focus(
                                  onFocusChange: (hasFocus) {
                                    if (!hasFocus) {
                                      final v = _titleController.text;
                                      final updatedMetadata = widget
                                          .movie
                                          .metadata
                                          ?.copyWith(title: v);
                                      widget.onUpdateMovie(
                                        widget.movie.copyWith(
                                          metadata: updatedMetadata,
                                        ),
                                      );
                                    }
                                  },
                                  child: TextBox(
                                    controller: _titleController,
                                    onSubmitted: (v) {
                                      final updatedMetadata = widget
                                          .movie
                                          .metadata
                                          ?.copyWith(title: v);
                                      widget.onUpdateMovie(
                                        widget.movie.copyWith(
                                          metadata: updatedMetadata,
                                        ),
                                      );
                                    },
                                    style: TagDocTextStyles.cardTitle,
                                    decoration: WidgetStateProperty.all(
                                      const BoxDecoration(
                                        border: Border(), // No border
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(0),
                                    highlightColor:
                                        TagDocColors.surfaceContainerHigh,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              FluentIcons.delete,
                              color: TagDocColors.onSurfaceVariant,
                            ),
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
                            // Year Textfield
                            child: V2TextField(
                              label: 'Release',
                              controller: _yearController,
                              onSubmitted: (v) {
                                final updatedMetadata = widget.movie.metadata
                                    ?.copyWith(releaseDate: v);
                                widget.onUpdateMovie(
                                  widget.movie.copyWith(
                                    metadata: updatedMetadata,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: V2Dropdown(
                              label: 'Resolution',
                              value: _resolution,
                              items: SettingsManager.resolutions,
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() {
                                    _resolution = v;
                                    widget.onUpdateMovie(
                                      widget.movie.copyWith(
                                        height: int.parse(
                                          v.substring(0, v.length - 1),
                                        ),
                                      ),
                                    );
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: V2Dropdown(
                              label: 'Quality',
                              value: _quality,
                              items: List<String>.from(
                                SettingsManager.qualities.map(
                                  (q) => q.displayName,
                                ),
                              ),
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() {
                                    _quality = v;
                                    widget.onUpdateMovie(
                                      widget.movie.copyWith(quality: v),
                                    );
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: V2Dropdown(
                              label: 'Source',
                              value: _source,
                              items: List<String>.from(
                                SettingsManager.sources.map(
                                  (s) => s.displayName,
                                ),
                              ),
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() {
                                    _source = v;
                                    widget.onUpdateMovie(
                                      widget.movie.copyWith(source: v),
                                    );
                                  });
                                }
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
