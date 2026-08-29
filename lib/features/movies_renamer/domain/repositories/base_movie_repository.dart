import 'package:fpdart/fpdart.dart';
import 'package:tagdoc/core/error/failure.dart';
import 'package:tagdoc/core/domain/entities/movie.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/rename_movie_usecase.dart';

abstract class BaseMovieRepository {
  /// Prompts the user to select video files and loads their metadata.
  ///
  /// Optionally reports loading progress via [onProgress].
  Future<Either<Failure, List<Movie>>> getMoviesFromDirectory({
    void Function(int current, int total)? onProgress,
  });

  /// Loads movie metadata for the provided file [paths].
  ///
  /// Optionally reports loading progress via [onProgress].
  Future<Either<Failure, List<Movie>>> loadMoviesFromPaths(
    List<String> paths, {
    void Function(int current, int total)? onProgress,
  });

  Future<Either<Failure, Movie>> renameMovie(RenameMovieParams params);

  List<Movie> getInitialMovies();

  void saveMovies(List<Movie> movies);

  void clearAllMovies();

  Future<Either<Failure, void>> exportMoviesToCsv(List<Movie> movies);

  void removeMovie(Movie movie);
}
