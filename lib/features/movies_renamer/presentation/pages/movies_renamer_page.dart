import 'package:desktop_drop/desktop_drop.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagdoc/core/constants/app_constants.dart';
import 'package:tagdoc/core/presentation/dialog_utils.dart';
import 'package:tagdoc/core/presentation/overlay_utils.dart';
import 'package:tagdoc/core/presentation/widgets/app_page_scaffold.dart';
import 'package:tagdoc/core/presentation/widgets/app_progress_bar.dart';
import 'package:tagdoc/core/theme/tagdoc_theme.dart';
import 'package:tagdoc/features/movies_renamer/presentation/bloc/movies_renamer_bloc.dart';
import 'package:tagdoc/features/movies_renamer/presentation/widgets/action_sidebar.dart';
import 'package:tagdoc/features/movies_renamer/presentation/widgets/movie_card.dart';
import 'package:tagdoc/init_dependencies.dart';

class MoviesRenamerPage extends StatelessWidget {
  const MoviesRenamerPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('MoviesRenamerPage build');
    return BlocProvider(
      create: (context) => serviceLocator<MoviesRenamerBloc>(),
      child: _MoviesRenamerPageContent(),
    );
  }
}

class _MoviesRenamerPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MoviesRenamerBloc>();
    return BlocListener<MoviesRenamerBloc, MoviesRenamerState>(
      listener: (context, state) {
        if (state is MoviesRenamerSuccess) {
          OverlayUtils.showSuccess(context, state.message);
        } else if (state is MoviesRenamerError) {
          OverlayUtils.showError(context, state.message);
        }
      },
      child: AppPageScaffold(
        title: AppConstants.renamerPageTitle,
        child: Row(
          children: [
            // Main Content Canvas
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: TagDocColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child:
                                BlocBuilder<
                                  MoviesRenamerBloc,
                                  MoviesRenamerState
                                >(
                                  buildWhen: (previous, current) {
                                    return (current is MoviesSelectionChanged ||
                                            current is MoviesRenamerLoaded) &&
                                        previous.selectedMoviePaths.length !=
                                            current.selectedMoviePaths.length;
                                  },
                                  builder: (context, state) {
                                    return Text(
                                      '${bloc.state.selectedMoviePaths.length} Items Selected',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: TagDocColors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                          ),
                          const SizedBox(width: 8),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                bloc.add(const ClearSelectedMoviesEvent());
                              },
                              child: const Text(
                                'Clear',
                                style: TextStyle(
                                  color: TagDocColors.onSurfaceVariant,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Movie Card List
                  Expanded(child: MoviesCardsListviewWdgt(bloc: bloc)),
                ],
              ),
            ),
            const SizedBox(width: 40),
            // Action Sidebar (Right Panel)
            SingleChildScrollView(
              child: BlocBuilder<MoviesRenamerBloc, MoviesRenamerState>(
                buildWhen: (previous, current) {
                  return (previous is MoviesRenamerLoading) !=
                      (current is MoviesRenamerLoading);
                },
                builder: (context, state) {
                  final isLoading = state is MoviesRenamerLoading;
                  return ActionSidebar(
                    isLoading: isLoading,
                    onRenameAll: () {
                      bloc.add(const RenameAllMoviesEvent());
                    },
                    onExport: () {
                      bloc.add(const ExportMoviesEvent());
                    },
                    onAddMovies: () {
                      bloc.add(const SelectMoviesEvent());
                    },
                    onClearAll: () => DialogUtils.showConfirmation(
                      context: context,
                      title: 'Clear All Movies',
                      content:
                          'Are you sure you want to clear all movies? This action cannot be undone.',
                      confirmText: 'Clear All',
                      onConfirm: () => bloc.add(const ClearAllMoviesEvent()),
                    ),
                    onApplyBatchChanges: ({resolution, quality, source}) {
                      bloc.add(
                        ApplyBatchEditEvent(
                          resolution: resolution,
                          quality: quality,
                          source: source,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoviesCardsListviewWdgt extends StatefulWidget {
  const MoviesCardsListviewWdgt({super.key, required this.bloc});

  final MoviesRenamerBloc bloc;

  @override
  State<MoviesCardsListviewWdgt> createState() =>
      _MoviesCardsListviewWdgtState();
}

class _MoviesCardsListviewWdgtState extends State<MoviesCardsListviewWdgt> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (_) => setState(() => _isDragging = true),
      onDragExited: (_) => setState(() => _isDragging = false),
      onDragDone: (event) {
        final filePaths = event.files.map((file) => file.path).toList();
        widget.bloc.add(DragAndDropMoviesEvent(filePaths: filePaths));
      },
      child: Container(
        color: _isDragging
            ? Colors.blue.withValues(alpha: 0.2)
            : Colors.transparent,
        child: BlocBuilder<MoviesRenamerBloc, MoviesRenamerState>(
          buildWhen: (previous, current) {
            return current is MoviesRenamerLoaded ||
                current is MoviesRenamerLoading ||
                (previous is MoviesRenamerLoading &&
                    current is! MoviesRenamerLoading) ||
                previous.movies != current.movies;
          },
          builder: (context, state) {
            debugPrint('Listview rebuild, state: ${state.runtimeType}');

            // 1. Loading State
            if (state is MoviesRenamerLoading) {
              if (state.movies.isEmpty) {
                // Centered loading bar when no movies have been loaded yet
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: AppProgressBar(
                      current: state.current,
                      total: state.total,
                      title: 'Opening Files...',
                      statusMessage: state.statusMessage,
                    ),
                  ),
                );
              }

              // Loading additional movies with existing list displayed
              return Column(
                children: [
                  AppProgressBar(
                    current: state.current,
                    total: state.total,
                    title: 'Opening Files...',
                    statusMessage: state.statusMessage,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.movies.length,
                      itemExtent: 136.0,
                      addAutomaticKeepAlives: false,
                      itemBuilder: (context, index) {
                        return MovieCard(
                          key: ValueKey(state.movies[index].filePath),
                          movie: state.movies[index],
                          onUpdateMovie: (updatedMovie) {
                            widget.bloc.add(
                              UpdateMovieDataEvent(updatedMovie: updatedMovie),
                            );
                          },
                          onRemoveMovie: () {
                            widget.bloc.add(
                              RemoveMovieEvent(movie: state.movies[index]),
                            );
                          },
                          onToggleMovieSelection: (isSelected) {
                            widget.bloc.add(
                              ToggleMovieSelectionEvent(
                                moviePath: state.movies[index].filePath,
                                isSelected: isSelected,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            // 2. Loaded State
            if (state is MoviesRenamerLoaded) {
              if (state.movies.isEmpty) {
                return const Center(
                  child: Text(
                    'No movies added. Click "Add Movies" to start.',
                    style: TextStyle(color: TagDocColors.onSurfaceVariant),
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.movies.length,
                itemExtent: 136.0,
                addAutomaticKeepAlives: false,
                itemBuilder: (context, index) {
                  return MovieCard(
                    key: ValueKey(state.movies[index].filePath),
                    movie: state.movies[index],
                    onUpdateMovie: (updatedMovie) {
                      widget.bloc.add(
                        UpdateMovieDataEvent(updatedMovie: updatedMovie),
                      );
                    },
                    onRemoveMovie: () {
                      widget.bloc.add(
                        RemoveMovieEvent(movie: state.movies[index]),
                      );
                    },
                    onToggleMovieSelection: (isSelected) {
                      widget.bloc.add(
                        ToggleMovieSelectionEvent(
                          moviePath: state.movies[index].filePath,
                          isSelected: isSelected,
                        ),
                      );
                    },
                  );
                },
              );
            }

            // 3. Initial or fallback state
            return const Center(
              child: Text(
                'Select some movies to begin renaming',
                style: TextStyle(color: TagDocColors.onSurfaceVariant),
              ),
            );
          },
        ),
      ),
    );
  }
}
