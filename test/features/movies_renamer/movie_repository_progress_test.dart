import 'package:flutter_test/flutter_test.dart';
import 'package:tagdoc/features/movies_renamer/data/datasources/local_file_data_source.dart';
import 'package:tagdoc/features/movies_renamer/data/datasources/movie_metadata_data_source.dart';
import 'package:tagdoc/features/movies_renamer/data/repositories/movie_repository_impl.dart';
import 'package:tagdoc/features/movies_renamer/presentation/bloc/movies_renamer_bloc.dart';

class FakeLocalFileDataSource extends LocalFileDataSource {
  final List<String> paths;
  FakeLocalFileDataSource(this.paths);

  @override
  Future<List<String>> selectFiles() async => paths;
}

class FakeMovieMetadataDataSource extends BaseMovieMetadataDataSource {
  @override
  Future<String?> getMovieMetadataFromFile(String filePath) async {
    return '{"title":"Test Movie","size":"1.50 GB","resolution":{"width":"1920","height":"1080"},"duration":"01:45:00"}';
  }
}

void main() {
  group('MovieRepository Progress Reporting', () {
    test('reports incremental progress as files are processed', () async {
      final fakeLocal = FakeLocalFileDataSource([
        'C:\\test\\movie1.mp4',
        'C:\\test\\movie2.mp4',
        'C:\\test\\movie3.mp4',
      ]);
      final fakeMetadata = FakeMovieMetadataDataSource();

      final repository = MovieRepositoryImpl(
        localFileDataSource: fakeLocal,
        movieMetadataDataSource: fakeMetadata,
      );

      final progressEvents = <Map<String, int>>[];

      final result = await repository.getMoviesFromDirectory(
        onProgress: (current, total) {
          progressEvents.add({'current': current, 'total': total});
        },
      );

      expect(result.isRight(), isTrue);
      expect(progressEvents.length, 4);
      expect(progressEvents[0], {'current': 0, 'total': 3});
      expect(progressEvents[1], {'current': 1, 'total': 3});
      expect(progressEvents[2], {'current': 2, 'total': 3});
      expect(progressEvents[3], {'current': 3, 'total': 3});
    });
  });

  group('MoviesRenamerLoading State', () {
    test('computes progress and percentage getters correctly', () {
      const loadingState = MoviesRenamerLoading(
        movies: [],
        current: 25,
        total: 100,
        statusMessage: 'Loading...',
      );

      expect(loadingState.progress, 0.25);
      expect(loadingState.percentage, 25.0);
      expect(loadingState.percentageString, '25%');
    });

    test('returns null for progress when total is 0 (indeterminate)', () {
      const loadingState = MoviesRenamerLoading(
        movies: [],
        current: 0,
        total: 0,
      );

      expect(loadingState.progress, isNull);
      expect(loadingState.percentage, isNull);
      expect(loadingState.percentageString, isNull);
    });
  });
}
