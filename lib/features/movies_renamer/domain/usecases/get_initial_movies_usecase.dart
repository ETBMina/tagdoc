import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tagdoc/core/error/failure.dart';
import 'package:tagdoc/core/usecase/base_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie.dart';
import 'package:tagdoc/features/movies_renamer/domain/repositories/base_movie_repository.dart';

class GetInitialMoviesUsecase
    extends BaseUsecase<List<Movie>, GetInitialMoviesParams> {
  final BaseMovieRepository repository;

  GetInitialMoviesUsecase({required this.repository});

  @override
  Future<Either<Failure, List<Movie>>> call(
    GetInitialMoviesParams params,
  ) async {
    return Right(repository.getInitialMovies());
  }
}

class GetInitialMoviesParams extends Equatable {
  const GetInitialMoviesParams();

  @override
  List<Object?> get props => [];
}
