import 'package:equatable/equatable.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie_metadata.dart';

class Movie extends Equatable {
  final String filePath;
  final String fileName;
  final String fileSize;
  final int width;
  final int height;
  final MovieMetadata? metadata;

  const Movie({
    required this.filePath,
    required this.fileName,
    required this.fileSize,
    required this.width,
    required this.height,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    filePath,
    fileName,
    fileSize,
    width,
    height,
    metadata,
  ];
}
