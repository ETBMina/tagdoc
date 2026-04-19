import 'package:equatable/equatable.dart';
import 'package:tagdoc/core/usecase/base_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/repositories/base_movie_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tagdoc/core/error/failure.dart';

class ExportMoviesUsecase extends BaseUsecase<void, ExportMoviesParams> {
  final BaseMovieRepository repository;

  ExportMoviesUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ExportMoviesParams params) async {
    return await repository.exportMoviesToCsv();
  }
}

class ExportMoviesParams extends Equatable {
  @override
  List<Object?> get props => [];
}
