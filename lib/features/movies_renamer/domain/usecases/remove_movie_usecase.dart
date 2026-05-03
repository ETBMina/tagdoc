import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tagdoc/core/error/failure.dart';
import 'package:tagdoc/core/usecase/base_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie.dart';
import 'package:tagdoc/features/movies_renamer/domain/repositories/base_movie_repository.dart';

class RemoveMovieUsecase extends BaseUsecase<void, RemoveMovieParams> {
  final BaseMovieRepository repository;

  RemoveMovieUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(RemoveMovieParams params) async {
    repository.removeMovie(params.movie);
    return Right(null);
  }
}

class RemoveMovieParams extends Equatable {
  final Movie movie;

  const RemoveMovieParams({required this.movie});

  @override
  List<Object?> get props => [movie];
}
