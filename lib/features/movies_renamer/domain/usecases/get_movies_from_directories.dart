import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tagdoc/core/error/failure.dart';
import 'package:tagdoc/core/usecase/base_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie.dart';
import 'package:tagdoc/features/movies_renamer/domain/repositories/base_movie_repository.dart';

class GetMoviesFromDirectories
    extends BaseUsecase<List<Movie>, MoviesFromDirectoriesParams> {
  final BaseMovieRepository repository;

  GetMoviesFromDirectories({required this.repository});

  @override
  Future<Either<Failure, List<Movie>>> call(
    MoviesFromDirectoriesParams params,
  ) async {
    return await repository.getMoviesFromDirectory(params);
  }
}

class MoviesFromDirectoriesParams extends Equatable {
  final String path;

  const MoviesFromDirectoriesParams({required this.path});

  @override
  List<Object?> get props => [path];
}
