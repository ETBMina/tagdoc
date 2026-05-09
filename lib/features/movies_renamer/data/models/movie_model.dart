import 'package:tagdoc/features/movies_renamer/data/models/movie_metadata_model.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie.dart';
import 'package:tagdoc/core/config/settings_manager.dart';
import 'package:path/path.dart' as p;

class MovieModel extends Movie {
  const MovieModel({
    required super.filePath,
    required super.fileName,
    required super.fileSize,
    required super.width,
    required super.height,
    required super.quality,
    super.source,
    super.duration,
    super.metadata,
    super.poster,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json, String filePath) {
    try {
      final fileName = p.basename(filePath);
      // Extract poster base64 data from the poster object if present
      final posterObj = json['poster'] as Map<String, dynamic>?;
      final posterData = posterObj?['data'] as String?;

      return MovieModel(
        filePath: filePath,
        fileName: fileName,
        fileSize: json['size'] as String? ?? '0.00',
        width: int.parse(json['resolution']?['width'] ?? '0'),
        height: int.parse(json['resolution']?['height'] ?? '0'),
        quality: SettingsManager.predictQuality(fileName),
        source: SettingsManager.predictSource(fileName),
        duration: json['duration'] as String?,
        metadata: MovieMetadataModel.fromJson(json),
        poster: posterData,
      );
    } catch (e) {
      throw FormatException('Error parsing MovieModel from JSON: $e');
    }
  }
}
