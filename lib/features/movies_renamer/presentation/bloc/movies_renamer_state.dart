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
  /// The count of files processed so far.
  final int current;

  /// The total count of files to process.
  final int total;

  /// An optional status message describing the active task.
  final String? statusMessage;

  const MoviesRenamerLoading({
    required super.movies,
    super.selectedMoviePaths,
    this.current = 0,
    this.total = 0,
    this.statusMessage,
  });

  /// Computes progress ratio between 0.0 and 1.0.
  /// Returns `null` when [total] <= 0 for automatic indeterminate loading.
  double? get progress =>
      (total > 0 && current >= 0) ? (current / total).clamp(0.0, 1.0) : null;

  /// Computes percentage value between 0.0 and 100.0.
  double? get percentage => progress != null ? progress! * 100.0 : null;

  /// Formatted percentage string (e.g., "45%").
  String? get percentageString =>
      percentage != null ? '${percentage!.toInt()}%' : null;

  @override
  List<Object?> get props => [
    movies,
    selectedMoviePaths,
    current,
    total,
    statusMessage,
  ];
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
