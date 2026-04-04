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
  final Map<Movie, String> newNamesMap;

  const RenameAllMoviesEvent({required this.newNamesMap});

  @override
  List<Object?> get props => [newNamesMap];
}

class GetInitialMoviesEvent extends MoviesRenamerEvent {
  const GetInitialMoviesEvent();
}
