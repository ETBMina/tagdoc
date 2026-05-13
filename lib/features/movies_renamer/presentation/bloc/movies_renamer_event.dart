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

class ClearAllMoviesEvent extends MoviesRenamerEvent {
  const ClearAllMoviesEvent();
}

class DragAndDropMoviesEvent extends MoviesRenamerEvent {
  final List<String> filePaths;
  const DragAndDropMoviesEvent({required this.filePaths});

  @override
  List<Object?> get props => [filePaths];
}

class ExportMoviesEvent extends MoviesRenamerEvent {
  const ExportMoviesEvent();
}

class RemoveMovieEvent extends MoviesRenamerEvent {
  final Movie movie;
  const RemoveMovieEvent({required this.movie});

  @override
  List<Object?> get props => [movie];
}

class ToggleMovieSelectionEvent extends MoviesRenamerEvent {
  final String moviePath;
  final bool isSelected;

  const ToggleMovieSelectionEvent({
    required this.moviePath,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [moviePath, isSelected];
}

class ApplyBatchEditEvent extends MoviesRenamerEvent {
  final String? resolution;
  final String? quality;
  final String? source;

  const ApplyBatchEditEvent({this.resolution, this.quality, this.source});

  @override
  List<Object?> get props => [resolution, quality, source];
}

class ClearSelectedMoviesEvent extends MoviesRenamerEvent {
  const ClearSelectedMoviesEvent();
}
