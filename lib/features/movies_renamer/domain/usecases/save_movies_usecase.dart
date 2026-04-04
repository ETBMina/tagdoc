import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tagdoc/core/error/failure.dart';
import 'package:tagdoc/core/usecase/base_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie.dart';
import 'package:tagdoc/features/movies_renamer/domain/repositories/base_movie_repository.dart';

class SaveMoviesUsecase extends BaseUsecase<void, SaveMoviesParams> {
  final BaseMovieRepository repository;

  SaveMoviesUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SaveMoviesParams params) async {
    repository.saveMovies(params.movies);
    return Right(null);
  }
}

class SaveMoviesParams extends Equatable {
  final List<Movie> movies;

  const SaveMoviesParams({required this.movies});

  @override
  List<Object?> get props => [movies];
}
