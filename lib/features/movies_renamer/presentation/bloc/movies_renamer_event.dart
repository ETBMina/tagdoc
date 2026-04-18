part of 'movies_renamer_bloc.dart';

abstract class MoviesRenamerEvent extends Equatable {
  const MoviesRenamerEvent();

  @override
  List<Object?> get props => [];
}

class SelectMoviesEvent extends MoviesRenamerEvent {
  const SelectMoviesEvent();
}

class RenameAllMoviesEvent extends MoviesRenamerEvent {
  const RenameAllMoviesEvent();

  @override
  List<Object?> get props => [];
}

class GetInitialMoviesEvent extends MoviesRenamerEvent {
  const GetInitialMoviesEvent();
}

class UpdateMovieDataEvent extends MoviesRenamerEvent {
  final Movie updatedMovie;
  const UpdateMovieDataEvent({required this.updatedMovie});

  @override
  List<Object?> get props => [updatedMovie];
}
