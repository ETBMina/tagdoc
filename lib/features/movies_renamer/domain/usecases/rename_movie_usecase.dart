import 'package:equatable/equatable.dart';
import 'package:tagdoc/core/error/failure.dart';
import 'package:tagdoc/core/usecase/base_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie.dart';
import 'package:tagdoc/features/movies_renamer/domain/repositories/base_movie_repository.dart';
import 'package:fpdart/fpdart.dart';

class RenameMovieUsecase extends BaseUsecase<Movie, RenameMovieParams> {
  final BaseMovieRepository repository;

  RenameMovieUsecase({required this.repository});

  @override
  Future<Either<Failure, Movie>> call(RenameMovieParams params) async {
    return await repository.renameMovie(params);
  }
}

class RenameMovieParams extends Equatable {
  final Movie movie;
  final String newFileName;
  const RenameMovieParams({required this.movie, required this.newFileName});

  @override
  List<Object?> get props => [movie, newFileName];
}
