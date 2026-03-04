import 'package:tagdoc/features/movies_renamer/data/models/movie_metadata_model.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie.dart';
import 'package:path/path.dart' as p;

class MovieModel extends Movie {
  const MovieModel({
    required super.filePath,
    required super.fileName,
    required super.fileSize,
    required super.width,
    required super.height,
    super.metadata,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json, String filePath) {
    try {
      return MovieModel(
        filePath: filePath,
        fileName: p.basename(filePath),
        fileSize: json['size'] as String? ?? '0.00',
        width: int.parse(json['resolution']?['width'] ?? '0'),
        height: int.parse(json['resolution']?['height'] ?? '0'),
        metadata: MovieMetadataModel.fromJson(json),
      );
    } catch (e) {
      throw FormatException('Error parsing MovieModel from JSON: $e');
    }
  }
}
