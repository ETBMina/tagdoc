import 'package:fpdart/fpdart.dart';
import 'package:tagdoc/core/error/failure.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/rename_movie_usecase.dart';

abstract class BaseMovieRepository {
  Future<Either<Failure, List<Movie>>> getMoviesFromDirectory();

  Future<Either<Failure, List<Movie>>> loadMoviesFromPaths(List<String> paths);

  Future<Either<Failure, Movie>> renameMovie(RenameMovieParams params);

  List<Movie> getInitialMovies();

  void saveMovies(List<Movie> movies);

  void clearAllMovies();

  Future<Either<Failure, void>> exportMoviesToCsv();
}
