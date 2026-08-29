import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tagdoc/core/config/settings_manager.dart';
import 'package:tagdoc/core/error/error_messages.dart';
import 'package:tagdoc/core/error/failure.dart';
import 'package:tagdoc/features/movies_renamer/data/models/movie_model.dart';
import 'package:tagdoc/core/domain/entities/movie.dart';
import 'package:tagdoc/features/movies_renamer/domain/repositories/base_movie_repository.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/rename_movie_usecase.dart';
import 'package:tagdoc/features/movies_renamer/data/datasources/local_file_data_source.dart';
import 'package:tagdoc/features/movies_renamer/data/datasources/movie_metadata_data_source.dart';
import 'dart:io';

class MovieRepositoryImpl implements BaseMovieRepository {
  final LocalFileDataSource localFileDataSource;
  final BaseMovieMetadataDataSource movieMetadataDataSource;
  List<Movie> _currentMovies = [];

  MovieRepositoryImpl({
    required this.localFileDataSource,
    required this.movieMetadataDataSource,
  });

  @override
  Future<Either<Failure, List<Movie>>> getMoviesFromDirectory({
    void Function(int current, int total)? onProgress,
  }) async {
    List<String> paths = await localFileDataSource.selectFiles();

    return loadMoviesFromPaths(paths, onProgress: onProgress);
  }

  @override
  Future<Either<Failure, List<Movie>>> loadMoviesFromPaths(
    List<String> paths, {
    void Function(int current, int total)? onProgress,
  }) async {
    if (paths.isEmpty) {
      return Left(Failure(message: ErrorMessages.noFilesSelected));
    }

    final total = paths.length;
    onProgress?.call(0, total);

    List<MovieModel> movies = [];
    for (int i = 0; i < paths.length; i++) {
      final path = paths[i];
      final rawJson = await movieMetadataDataSource.getMovieMetadataFromFile(
        path,
      );
      if (rawJson != null) {
        try {
          final movieModel = MovieModel.fromJson(jsonDecode(rawJson), path);
          movies.add(movieModel);
        } catch (_) {
          // If metadata JSON fails to parse, skip this file without breaking the entire batch
        }
      }
      onProgress?.call(i + 1, total);
    }

    if (movies.isEmpty) {
      return Left(Failure(message: ErrorMessages.movieMetadataNotFound));
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
      final updatedMovie = params.movie.copyWith(
        filePath: newPath,
        fileName: newFileName,
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

  @override
  void clearAllMovies() {
    _currentMovies.clear();
  }

  @override
  Future<Either<Failure, void>> exportMoviesToCsv(List<Movie> movies) async {
    try {
      List<List<dynamic>> rows = [
        ["Title", "Quality", "Resolution", "Size", "Source", "Duration"],
      ];

      for (var movie in movies) {
        rows.add(movie.toCsvRow());
      }

      String csvData = csv.encode(rows);

      Directory tempDir;
      try {
        tempDir = await getTemporaryDirectory();
      } catch (e) {
        tempDir = Directory.systemTemp;
      }

      final String filePath = '${tempDir.path}\\tagdoc_rename_export.csv';
      final File file = File(filePath);

      final sink = file.openWrite();
      sink.write('\uFEFF');
      sink.write(csvData);
      await sink.close();

      final Uri fileUri = Uri.file(filePath);

      bool launched = false;
      try {
        if (await canLaunchUrl(fileUri)) {
          await launchUrl(fileUri);
          launched = true;
        }
      } catch (e) {
        // Fallback safely handled below
      }

      if (!launched) {
        await Process.run('start', ['', filePath], runInShell: true);
      }

      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to export movies to CSV: $e'));
    }
  }

  @override
  void removeMovie(Movie movie) {
    _currentMovies.remove(movie);
  }
}
