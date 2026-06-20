import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tagdoc/features/movies_renamer/data/datasources/local_file_data_source.dart';
import 'package:tagdoc/features/movies_renamer/data/datasources/movie_metadata_data_source.dart';
import 'package:tagdoc/features/movies_renamer/data/repositories/movie_repository_impl.dart';
import 'package:tagdoc/features/movies_renamer/domain/usecases/get_movies_from_directories_usecase.dart';

/// A "fake" data source that bypasses the FilePicker UI and returns a static path.
class FakeLocalFileDataSource extends LocalFileDataSource {
  final String staticPath;

  FakeLocalFileDataSource(this.staticPath);

  @override
  Future<List<String>> selectFiles() async {
    return [staticPath];
  }
}

void main() {
  group('Data Layer Integration Test (Static File)', () {
    test('should fetch and print metadata for a static MP4 file', () async {
      // =====================================================================
      // IMPORTANT: Update this variable to point to a real MP4 on your PC!
      // Example: r'D:\Movies\MySampleVideo.mp4'
      // =====================================================================
      const staticMp4Path = r'C:\Users\Guardiola\Desktop\test.mp4';

      print('Starting test with static file: $staticMp4Path');

      // 1. Setup the Data Sources
      // We use the FAKE local source (to avoid FilePicker UI)
      final fakeLocalDataSource = FakeLocalFileDataSource(staticMp4Path);
      // We use the REAL metadata source to hit the FFI/C++ DLL
      final realMetadataDataSource = MovieMetadataDataSource();

      // 2. Setup the Repository
      final repository = MovieRepositoryImpl(
        localFileDataSource: fakeLocalDataSource,
        movieMetadataDataSource: realMetadataDataSource,
      );

      // 3. Execute the repository logic
      final result = await repository.getMoviesFromDirectory();

      // 4. Print and verify the results
      result.fold(
        (failure) {
          print('❌ FAILED: ${failure.message}');
          fail('Expected success but got failure: ${failure.message}');
        },
        (movies) {
          print('\n✅ === METADATA RESULT ===');
          if (movies.isEmpty) {
            print('No movies found!');
          }
          for (var movie in movies) {
            print('File Name:  ${movie.fileName}');
            print('File Path:  ${movie.filePath}');
            print('File Size:  ${movie.fileSize}');
            print('Resolution: ${movie.width}x${movie.height}');

            if (movie.metadata != null) {
              print('Metadata Properties:');
              // print specific properties if your MovieMetadata entity has them.
              // We just print it using the implicit toString() for now
              print(movie.metadata);
            } else {
              print('Metadata object is null.');
            }
          }
          print('===========================\n');

          // Basic test assertions
          expect(movies, isNotEmpty);
          expect(movies.first.filePath, staticMp4Path);
        },
      );
    });
  });
}
