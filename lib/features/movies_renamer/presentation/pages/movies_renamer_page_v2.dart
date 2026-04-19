import 'package:desktop_drop/desktop_drop.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagdoc/core/theme/tagdoc_theme.dart';
import 'package:tagdoc/features/movies_renamer/presentation/bloc/movies_renamer_bloc.dart';
import 'package:tagdoc/features/movies_renamer/presentation/widgets/v2/action_sidebar_v2.dart';
import 'package:tagdoc/features/movies_renamer/presentation/widgets/v2/movie_card_v2.dart';
import 'package:tagdoc/init_dependencies.dart';

class MoviesRenamerPageV2 extends StatelessWidget {
  const MoviesRenamerPageV2({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('MoviesRenamerPageV2 build');
    return BlocProvider(
      create: (context) => serviceLocator<MoviesRenamerBloc>(),
      child: Builder(
        builder: (context) {
          final bloc = context.read<MoviesRenamerBloc>();
          return ScaffoldPage(
            padding: EdgeInsets.zero,
            content: Container(
              color: TagDocColors.surface,
              child: Row(
                children: [
                  // Main Content Canvas
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Renamer',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: TagDocColors.onSurface,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: TagDocColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      '02 Items Selected',
                                      style: TextStyle(
                                        color: TagDocColors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: const Text(
                                          'Clear',
                                          style: TextStyle(
                                            color:
                                                TagDocColors.onSurfaceVariant,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Movie Card List
                          Expanded(child: MoviesCardsListviewWdgt(bloc: bloc)),
                        ],
                      ),
                    ),
                  ),

                  // Action Sidebar (Right Panel)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40,
                      bottom: 40,
                      right: 40,
                    ),
                    child: SingleChildScrollView(
                      child: ActionSidebarV2(
                        onRenameAll: () {
                          bloc.add(const RenameAllMoviesEvent());
                        },
                        onExport: () {
                          bloc.add(const ExportMoviesEvent());
                        },
                        onAddMovies: () {
                          bloc.add(const SelectMoviesEvent());
                        },
                        onClearAll: () {
                          bloc.add(const ClearAllMoviesEvent());
                        },
                        onApplyBatchChanges: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
            return current is MoviesRenamerLoaded;
          },
          builder: (context, state) {
            debugPrint('Listview rebuild');
            // if (state is MoviesRenamerLoading) {
            //   return const Center(child: ProgressBar());
            // } else
            if (state is MoviesRenamerError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: TagDocColors.error),
                ),
              );
            } else if (state is MoviesRenamerLoaded) {
              if (state.movies.isEmpty) {
                return const Center(
                  child: Text(
                    'No movies added. Click "Add Movies" to start.',
                    style: TextStyle(color: TagDocColors.onSurfaceVariant),
                  ),
                );
              }
              debugPrint('Listview rebuild2');
              return ListView.builder(
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  return MovieCardV2(
                    movie: state.movies[index],
                    onUpdateMovie: (updatedMovie) {
                      widget.bloc.add(
                        UpdateMovieDataEvent(updatedMovie: updatedMovie),
                      );
                    },
                  );
                },
              );
            }

            // Initial state or other states
            print('Initial State');
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
