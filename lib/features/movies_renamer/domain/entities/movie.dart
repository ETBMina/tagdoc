import 'package:equatable/equatable.dart';
import 'package:tagdoc/features/movies_renamer/domain/entities/movie_metadata.dart';
import 'package:path/path.dart' as p;

class Movie extends Equatable {
  final String filePath;
  final String fileName;
  final String fileSize;
  final int width;
  final int height;
  final String quality;
  final String? source;
  final String? duration;
  final MovieMetadata? metadata;

  const Movie({
    required this.filePath,
    required this.fileName,
    required this.fileSize,
    required this.width,
    required this.height,
    required this.quality,
    this.source,
    this.duration,
    this.metadata,
  });

  List<dynamic> toCsvRow() {
    return [
      metadata?.title ?? fileName,
      quality,
      getResolutionString(),
      fileSize,
      source ?? '',
      duration ?? '',
    ];
  }

  String getFormattedName(String format) {
    if (metadata == null) return fileName;

    String year = '';
    if (metadata!.releaseDate.isNotEmpty) {
      year = metadata!.releaseDate.split('-').first;
    }

    String res = getResolutionString();
    String qual = quality;
    String src = source ?? ''; // Can be empty if unset

    String newName = format
        .replaceAll('{title}', metadata!.title)
        .replaceAll('{year}', year)
        .replaceAll('{resolution}', res)
        .replaceAll('{quality}', qual)
        .replaceAll('{source}', src);

    // Replace illegal filename characters with underscores
    String sanitized = newName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');

    // Clean up multiple spaces, trim, and handle loose dashes or brackets that might result from an empty source
    sanitized = sanitized.replaceAll(RegExp(r'\s+'), ' ').trim();
    // E.g., if format was "[{source}]" and source is empty, we might have "[]". Let's clean empty brackets:
    sanitized = sanitized
        .replaceAll(RegExp(r'\[\s*\]'), '')
        .replaceAll(RegExp(r'\(\s*\)'), '');
    // Add the extension from the original file
    final extension = p.extension(filePath);
    return '${sanitized.replaceAll(RegExp(r'\s+'), ' ').trim()}$extension';
  }

  String getResolutionString() {
    if (width >= 3840 || height >= 2160) return '2160p';
    if (width >= 1920 || height >= 1080) return '1080p';
    if (width >= 1280 || height >= 720) return '720p';
    return '${height}p';
  }

  @override
  List<Object?> get props => [
    filePath,
    fileName,
    fileSize,
    width,
    height,
    quality,
    source,
    duration,
    metadata,
  ];

  Movie copyWith({
    String? filePath,
    String? fileName,
    String? fileSize,
    int? width,
    int? height,
    String? quality,
    String? source,
    String? duration,
    MovieMetadata? metadata,
  }) {
    return Movie(
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      width: width ?? this.width,
      height: height ?? this.height,
      quality: quality ?? this.quality,
      source: source ?? this.source,
      duration: duration ?? this.duration,
      metadata: metadata ?? this.metadata,
    );
  }
}
