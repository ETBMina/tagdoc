import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:tagdoc/core/config/settings_manager.dart';
import 'package:tagdoc/core/error/error_messages.dart';
import 'package:tagdoc/core/error/failure.dart';
import 'package:tagdoc/features/movies_renamer/data/models/movie_model.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie.dart';
import 'package:tagdoc/features/movies_renamer/domain/repositories/base_movie_repository.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/get_movies_from_directories_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/rename_movie_usecase.dart';
import 'package:tagdoc/features/movies_renamer/data/datasources/local_file_data_source.dart';
import 'package:tagdoc/features/movies_renamer/data/datasources/movie_metadata_data_source.dart';

class MovieRepositoryImpl implements BaseMovieRepository {
  final LocalFileDataSource localFileDataSource;
  final MovieMetadataDataSource movieMetadataDataSource;
  List<Movie> _currentMovies = [];

  MovieRepositoryImpl({
    required this.localFileDataSource,
    required this.movieMetadataDataSource,
  });

  @override
  Future<Either<Failure, List<Movie>>> getMoviesFromDirectory(
    MoviesFromDirectoriesParams params,
  ) async {
    List<String> paths = await localFileDataSource.selectFiles();
    if (paths.isEmpty) {
      return Left(Failure(message: ErrorMessages.noFilesSelected));
    }
    List<MovieModel> movies = [];
    for (var path in paths) {
      final rawJson = movieMetadataDataSource.getMovieMetadataFromFile(path);
      if (rawJson == null) {
        return Left(Failure(message: ErrorMessages.movieMetadataNotFound));
      }
      MovieModel movieModel = MovieModel.fromJson(jsonDecode(rawJson), path);
      movies.add(movieModel);
    }
    _currentMovies = [..._currentMovies, ...movies];
    return Right(movies);
  }

  @override
  Future<Either<Failure, Movie>> renameMovie(RenameMovieParams params) async {
    try {
      final newFileName = params.movie.getFormattedName(
        SettingsManager.renameFormat,
      );
      final newPath = await localFileDataSource.renameFile(
        params.movie.filePath,
        newFileName,
      );

      // Create a new Movie object with the updated path and name
      final updatedMovie = MovieModel(
        filePath: newPath,
        fileName: newFileName,
        fileSize: params.movie.fileSize,
        width: params.movie.width,
        height: params.movie.height,
        quality: params.movie.quality,
        source: params.movie.source,
        metadata: params.movie.metadata,
      );

      return Right(updatedMovie);
    } catch (e) {
      return Left(Failure(message: 'Failed to rename movie: $e'));
    }
  }

  @override
  List<Movie> getInitialMovies() {
    return _currentMovies;
  }

  @override
  void saveMovies(List<Movie> movies) {
    // _currentMovies.clear();
    // _currentMovies.addAll(movies);
    _currentMovies = [...movies];
  }
}
