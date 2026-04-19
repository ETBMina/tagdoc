import 'package:get_it/get_it.dart';
import 'package:tagdoc/features/movies_renamer/data/datasources/local_file_data_source.dart';
import 'package:tagdoc/features/movies_renamer/data/datasources/movie_metadata_data_source.dart';
import 'package:tagdoc/features/movies_renamer/data/repositories/movie_repository_impl.dart';
import 'package:tagdoc/features/movies_renamer/domain/repositories/base_movie_repository.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/clear_all_movies_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/export_movies_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/get_initial_movies_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/get_movies_from_directories_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/load_movies_from_paths.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/rename_movie_usecase.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/save_movies_usecase.dart';
import 'package:tagdoc/features/movies_renamer/presentation/bloc/movies_renamer_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initMoviesRenamer();
}

void _initMoviesRenamer() {
  // 1. Data Sources
  serviceLocator.registerLazySingleton(() => LocalFileDataSource());
  serviceLocator.registerLazySingleton(() => MovieMetadataDataSource());

  // 2. Repositories
  serviceLocator.registerLazySingleton<BaseMovieRepository>(
    () => MovieRepositoryImpl(
      localFileDataSource: serviceLocator(),
      movieMetadataDataSource: serviceLocator(),
    ),
  );

  // 3. Use Cases
  serviceLocator.registerLazySingleton(
    () => GetMoviesFromDirectoriesUsecase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => RenameMovieUsecase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetInitialMoviesUsecase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SaveMoviesUsecase(repository: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => ClearAllMoviesUsecase(repository: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => LoadMoviesFromPathsUsecase(repository: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => ExportMoviesUsecase(repository: serviceLocator()),
  );

  // 4. BLoC
  serviceLocator.registerFactory(
    () => MoviesRenamerBloc(
      getMovies: serviceLocator(),
      renameMovie: serviceLocator(),
      getInitialMovies: serviceLocator(),
      saveMovies: serviceLocator(),
      clearAllMovies: serviceLocator(),
      loadMoviesFromPaths: serviceLocator(),
      exportMovies: serviceLocator(),
    ),
  );
}
