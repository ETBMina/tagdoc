part of 'movies_renamer_bloc.dart';

abstract class MoviesRenamerState extends Equatable {
  final List<Movie> movies;
  final Set<String> selectedMoviePaths;

  const MoviesRenamerState({
    required this.movies,
    this.selectedMoviePaths = const {},
  });

  @override
  List<Object?> get props => [movies, selectedMoviePaths];
}

class MoviesRenamerInitial extends MoviesRenamerState {
  const MoviesRenamerInitial() : super(movies: const []);
}

class MoviesRenamerLoading extends MoviesRenamerState {
  const MoviesRenamerLoading({required super.movies, super.selectedMoviePaths});
}

class MoviesRenamerLoaded extends MoviesRenamerState {
  const MoviesRenamerLoaded({required super.movies, super.selectedMoviePaths});
}

class MoviesRenamerError extends MoviesRenamerState {
  final String message;

  const MoviesRenamerError({
    required this.message,
    required super.movies,
    super.selectedMoviePaths,
  });
}

class MoviesRenamerSuccess extends MoviesRenamerState {
  final String message;

  const MoviesRenamerSuccess({
    required super.movies,
    required this.message,
    super.selectedMoviePaths,
  });

  @override
  List<Object?> get props => [movies, selectedMoviePaths, message];
}

class MoviesSelectionChanged extends MoviesRenamerState {
  const MoviesSelectionChanged({
    required super.movies,
    required super.selectedMoviePaths,
  });

  @override
  List<Object?> get props => [movies, selectedMoviePaths];
}
