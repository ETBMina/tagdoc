part of 'movies_renamer_bloc.dart';

abstract class MoviesRenamerState extends Equatable {
  final List<Movie> movies;
  const MoviesRenamerState({required this.movies});

  @override
  List<Object?> get props => [movies];
}

class MoviesRenamerInitial extends MoviesRenamerState {
  const MoviesRenamerInitial() : super(movies: const []);
}

class MoviesRenamerLoading extends MoviesRenamerState {
  const MoviesRenamerLoading({required super.movies});
}

class MoviesRenamerLoaded extends MoviesRenamerState {
  const MoviesRenamerLoaded({required super.movies});
}

class MoviesRenamerError extends MoviesRenamerState {
  final String message;

  const MoviesRenamerError({required this.message, required super.movies});
}

class MoviesRenamerSuccess extends MoviesRenamerState {
  const MoviesRenamerSuccess({required super.movies});
}
