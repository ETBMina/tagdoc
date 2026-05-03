import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/clear_all_movies_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/export_movies_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/get_initial_movies_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/get_movies_from_directories_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/load_movies_from_paths.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/remove_movie_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/rename_movie_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/save_movies_usecase.dart';

part 'movies_renamer_event.dart';
part 'movies_renamer_state.dart';

class MoviesRenamerBloc extends Bloc<MoviesRenamerEvent, MoviesRenamerState> {
  final GetMoviesFromDirectoriesUsecase _getMovies;
  final RenameMovieUsecase _renameMovie;
  final GetInitialMoviesUsecase _getInitialMovies;
  final SaveMoviesUsecase _saveMovies;
  final ClearAllMoviesUsecase _clearAllMovies;
  final LoadMoviesFromPathsUsecase _loadMoviesFromPaths;
  final ExportMoviesUsecase _exportMovies;
  final RemoveMovieUsecase _removeMovie;

  MoviesRenamerBloc({
    required GetMoviesFromDirectoriesUsecase getMovies,
    required RenameMovieUsecase renameMovie,
    required GetInitialMoviesUsecase getInitialMovies,
    required SaveMoviesUsecase saveMovies,
    required ClearAllMoviesUsecase clearAllMovies,
    required LoadMoviesFromPathsUsecase loadMoviesFromPaths,
    required ExportMoviesUsecase exportMovies,
    required RemoveMovieUsecase removeMovie,
  }) : _removeMovie = removeMovie,
       _clearAllMovies = clearAllMovies,
       _loadMoviesFromPaths = loadMoviesFromPaths,
       _saveMovies = saveMovies,
       _getInitialMovies = getInitialMovies,
       _getMovies = getMovies,
       _renameMovie = renameMovie,
       _exportMovies = exportMovies,
       super(MoviesRenamerInitial()) {
    on<GetInitialMoviesEvent>((event, emit) async {
      final result = await _getInitialMovies(const GetInitialMoviesParams());
      result.match(
        (failure) => null, // Or emit error if needed
        (movies) {
          if (movies.isNotEmpty) {
            emit(MoviesRenamerLoaded(movies: movies));
          }
        },
      );
    });

    add(const GetInitialMoviesEvent());

    on<SelectMoviesEvent>((event, emit) async {
      emit(MoviesRenamerLoading(movies: state.movies));
      final result = await _getMovies(const MoviesFromDirectoriesParams());
      result.match(
        (failure) => emit(
          MoviesRenamerError(message: failure.message, movies: state.movies),
        ),
        (newSelectedMovies) => emit(
          MoviesRenamerLoaded(movies: [...state.movies, ...newSelectedMovies]),
        ),
      );
    });

    on<DragAndDropMoviesEvent>((event, emit) async {
      emit(MoviesRenamerLoading(movies: state.movies));
      final result = await _loadMoviesFromPaths(
        LoadMoviesFromPathsParams(paths: event.filePaths),
      );
      result.match(
        (failure) => emit(
          MoviesRenamerError(message: failure.message, movies: state.movies),
        ),
        (newSelectedMovies) => emit(
          MoviesRenamerLoaded(movies: [...state.movies, ...newSelectedMovies]),
        ),
      );
    });

    on<RenameAllMoviesEvent>((event, emit) async {
      emit(MoviesRenamerLoading(movies: state.movies));

      List<Movie> updatedMovies = [];
      String? errorMessage;

      for (var movie in state.movies) {
        final result = await _renameMovie(RenameMovieParams(movie: movie));
        result.match(
          (failure) {
            errorMessage = failure.message;
          },
          (updatedMovie) {
            updatedMovies.add(updatedMovie);
          },
        );
        if (errorMessage != null) break; // stop on first error
      }

      if (errorMessage != null) {
        emit(MoviesRenamerError(message: errorMessage!, movies: state.movies));
      } else {
        emit(
          MoviesRenamerSuccess(
            movies: state.movies,
            message:
                'Successfully renamed ${updatedMovies.length} movie${updatedMovies.length == 1 ? '' : 's'}.',
          ),
        );
        emit(MoviesRenamerLoaded(movies: updatedMovies));
      }
    });

    on<UpdateMovieDataEvent>((event, emit) {
      if (state is MoviesRenamerLoaded) {
        final updatedMoviesList = state.movies.map((movie) {
          return movie.filePath == event.updatedMovie.filePath
              ? event.updatedMovie
              : movie;
        }).toList();

        emit(MoviesRenamerLoaded(movies: updatedMoviesList));
      }
    });

    on<ClearAllMoviesEvent>((event, emit) {
      _clearAllMovies(ClearAllMoviesParams());
      emit(MoviesRenamerLoaded(movies: []));
    });

    on<ExportMoviesEvent>((event, emit) async {
      await _exportMovies(ExportMoviesParams());
    });

    on<RemoveMovieEvent>((event, emit) async {
      if (state is! MoviesRenamerLoaded) return;
      await _removeMovie(RemoveMovieParams(movie: event.movie));
      final updatedMovies = List<Movie>.from(state.movies)..remove(event.movie);
      emit(MoviesRenamerLoaded(movies: updatedMovies));
    });
  }

  @override
  Future<void> close() {
    _saveMovies(SaveMoviesParams(movies: state.movies));
    return super.close();
  }
}
