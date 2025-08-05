import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tagdoc/core/error/failure.dart';
import 'package:tagdoc/core/usecase/base_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie_metadata.dart';
import 'package:tagdoc/features/movies_renamer/domain/repositories/base_movie_repository.dart';

class GetMovieMetadataUsecase
    extends BaseUsecase<MovieMetadata, MovieMetadataParams> {
  final BaseMovieRepository repository;

  GetMovieMetadataUsecase({required this.repository});
  @override
  Future<Either<Failure, MovieMetadata>> call(
    MovieMetadataParams params,
  ) async {
    return await repository.getMovieMetadata(params);
  }
}

class MovieMetadataParams extends Equatable {
  final Movie movie;
  const MovieMetadataParams({required this.movie});

  @override
  List<Object?> get props => [movie];
}
