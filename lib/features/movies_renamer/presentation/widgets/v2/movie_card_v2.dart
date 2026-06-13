import 'dart:convert';
import 'dart:typed_data';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagdoc/features/movies_renamer/presentation/bloc/movies_renamer_bloc.dart';
import 'package:tagdoc/core/config/settings_manager.dart';
import 'package:tagdoc/core/presentation/dialog_utils.dart';
import 'package:tagdoc/core/theme/tagdoc_theme.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie.dart';
import 'package:tagdoc/features/movies_renamer/presentation/widgets/v2/v2_dropdown.dart';
import 'package:tagdoc/features/movies_renamer/presentation/widgets/v2/v2_text_field.dart';

class MovieCardV2 extends StatefulWidget {
  final Movie movie;
  final Function(Movie updatedMovie) onUpdateMovie;
  final VoidCallback onRemoveMovie;
  final Function(bool isSelected) onToggleMovieSelection;

  const MovieCardV2({
    super.key,
    required this.movie,
    required this.onUpdateMovie,
    required this.onRemoveMovie,
    required this.onToggleMovieSelection,
  });

  @override
  State<MovieCardV2> createState() => _MovieCardV2State();
}

class _MovieCardV2State extends State<MovieCardV2> {
  late TextEditingController _titleController;
  late TextEditingController _yearController;
  Uint8List? _posterBytes;

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

    _decodePoster();
  }

  void _decodePoster() {
    if (widget.movie.poster != null) {
      try {
        _posterBytes = base64Decode(widget.movie.poster!);
      } catch (e) {
        debugPrint('Error decoding poster: $e');
        _posterBytes = null;
      }
    } else {
      _posterBytes = null;
    }
  }

  @override
  void didUpdateWidget(MovieCardV2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movie != widget.movie) {
      if (oldWidget.movie.poster != widget.movie.poster) {
        _decodePoster();
      }

      final metadata = widget.movie.metadata;
      final newTitle = metadata?.title ?? widget.movie.fileName;
      if (_titleController.text != newTitle) {
        _titleController.text = newTitle;
      }

      String year = '';
      if (metadata != null && metadata.releaseDate.isNotEmpty) {
        year = metadata.releaseDate.split('-').first;
      }
      if (_yearController.text != year) {
        _yearController.text = year;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MoviesRenamerBloc, MoviesRenamerState, bool>(
      selector: (state) =>
          state.selectedMoviePaths.contains(widget.movie.filePath),
      builder: (context, isSelected) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            color: isSelected
                ? TagDocColors.surfaceContainer
                : TagDocColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? TagDocColors.primary.withValues(alpha: 0.3)
                  : TagDocColors.outlineVariant.withValues(alpha: 0.1),
            ),
          ),
          child: Stack(
            children: [
              if (isSelected)
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
                      checked: isSelected,
                      onChanged: (val) {
                        widget.onToggleMovieSelection(val ?? false);
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
                      child: _posterBytes != null
                          ? Image.memory(
                              _posterBytes!,
                              fit: BoxFit.cover,
                              width: 64,
                              height: 96,
                              gaplessPlayback: true,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Icon(
                                      FluentIcons.my_movies_t_v,
                                      size: 24,
                                      color: TagDocColors.onSurfaceVariant,
                                    ),
                                  ),
                            )
                          : const Center(
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
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth < 120) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: TagDocColors.primary
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                'FILENAME',
                                                style:
                                                    TagDocTextStyles.pillLabel,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                widget.movie.fileName,
                                                style: TagDocTextStyles
                                                    .codeFilename,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
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
                                            highlightColor: TagDocColors
                                                .surfaceContainerHigh,
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
                                    onPressed: () => DialogUtils.showConfirmation(
                                      context: context,
                                      title: 'Remove Movie',
                                      content:
                                          'Are you sure you want to remove "${widget.movie.fileName}"?',
                                      confirmText: 'Remove',
                                      onConfirm: widget.onRemoveMovie,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final yearField = V2TextField(
                                    label: 'Release',
                                    controller: _yearController,
                                    onSubmitted: (v) {
                                      final updatedMetadata = widget
                                          .movie
                                          .metadata
                                          ?.copyWith(releaseDate: v);
                                      widget.onUpdateMovie(
                                        widget.movie.copyWith(
                                          metadata: updatedMetadata,
                                        ),
                                      );
                                    },
                                  );

                                  final resDropdown = V2Dropdown(
                                    label: 'Resolution',
                                    value: widget.movie.getResolutionString(),
                                    items: SettingsManager.resolutions,
                                    onChanged: (v) {
                                      if (v != null) {
                                        widget.onUpdateMovie(
                                          widget.movie.copyWith(
                                            height: int.parse(
                                              v.replaceAll('p', ''),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  );

                                  final qualityDropdown = V2Dropdown(
                                    label: 'Quality',
                                    value: widget.movie.quality,
                                    items: List<String>.from(
                                      SettingsManager.qualities.map(
                                        (q) => q.displayName,
                                      ),
                                    ),
                                    onChanged: (v) {
                                      if (v != null) {
                                        widget.onUpdateMovie(
                                          widget.movie.copyWith(quality: v),
                                        );
                                      }
                                    },
                                  );

                                  final sourceDropdown = V2Dropdown(
                                    label: 'Source',
                                    value: widget.movie.source ?? 'None',
                                    items: List<String>.from(
                                      SettingsManager.sources.map(
                                        (s) => s.displayName,
                                      ),
                                    ),
                                    onChanged: (v) {
                                      if (v != null) {
                                        widget.onUpdateMovie(
                                          widget.movie.copyWith(source: v),
                                        );
                                      }
                                    },
                                  );

                                  if (constraints.maxWidth > 500) {
                                    return Row(
                                      children: [
                                        Expanded(flex: 1, child: yearField),
                                        const SizedBox(width: 8),
                                        Expanded(flex: 2, child: resDropdown),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          flex: 2,
                                          child: qualityDropdown,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          flex: 2,
                                          child: sourceDropdown,
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        SizedBox(width: 80, child: yearField),
                                        SizedBox(
                                          width: 110,
                                          child: resDropdown,
                                        ),
                                        SizedBox(
                                          width: 110,
                                          child: qualityDropdown,
                                        ),
                                        SizedBox(
                                          width: 110,
                                          child: sourceDropdown,
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
