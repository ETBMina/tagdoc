import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tagdoc/core/error/failure.dart';
import 'package:tagdoc/core/usecase/base_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie.dart';
import 'package:tagdoc/features/movies_renamer/domain/repositories/base_movie_repository.dart';

class LoadMoviesFromPathsUsecase
    extends BaseUsecase<List<Movie>, LoadMoviesFromPathsParams> {
  final BaseMovieRepository repository;
  LoadMoviesFromPathsUsecase({required this.repository});

  @override
  Future<Either<Failure, List<Movie>>> call(LoadMoviesFromPathsParams params) {
    return repository.loadMoviesFromPaths(params.paths);
  }
}

class LoadMoviesFromPathsParams extends Equatable {
  final List<String> paths;
  const LoadMoviesFromPathsParams({required this.paths});

  @override
  List<Object?> get props => [paths];
}
