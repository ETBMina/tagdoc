import 'package:tagdoc/features/movies_renamer/domain/entities/movie_metadata.dart';

class MovieMetadataModel extends MovieMetadata {
  const MovieMetadataModel({
    required super.title,
    required super.releaseDate,
    required super.genres,
    required super.actors,
    required super.directors,
    required super.writers,
    super.overview,
    super.tagline,
    super.comment,
  });

  factory MovieMetadataModel.fromJson(Map<String, dynamic> json) {
    try {
      return MovieMetadataModel(
        title: json['title'] as String? ?? '',
        releaseDate: json['date'] as String? ?? '',
        genres: (json['genre'] as String?)?.split('|') ?? [],
        actors: (json['artist'] as String?)?.split('|') ?? [],
        directors: (json['encoder'] as String?)?.split('|') ?? [],
        writers: (json['composer'] as String?)?.split('|') ?? [],
        overview: json['synopsis'] as String?,
        tagline: json['description'] as String?,
        comment: json['comment'] as String?,
      );
    } catch (e) {
      // Provides a more detailed error message for debugging.
      throw FormatException('Error parsing MovieMetadataModel from JSON: $e');
    }
  }
}
