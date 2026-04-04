import 'package:fpdart/fpdart.dart';
import 'package:tagdoc/core/error/failure.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie.dart';

import 'package:tagdoc/features/movies_renamer/domain/usecases/get_movies_from_directories_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/rename_movie_usecase.dart';

abstract class BaseMovieRepository {
  Future<Either<Failure, List<Movie>>> getMoviesFromDirectory(
    MoviesFromDirectoriesParams params,
  );

  Future<Either<Failure, Movie>> renameMovie(RenameMovieParams params);

  List<Movie> getInitialMovies();

  void saveMovies(List<Movie> movies);
}
