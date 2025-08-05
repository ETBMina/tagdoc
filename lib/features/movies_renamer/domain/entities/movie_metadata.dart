import 'package:equatable/equatable.dart';

class MovieMetadata extends Equatable {
  final String title;
  final String releaseDate;
  final List<String> genres;
  final List<String> actors;
  final List<String> directors;
  final List<String> writers;
  final String? overview;
  final String? tagline;
  final String? comment;

  const MovieMetadata({
    required this.title,
    required this.genres,
    required this.releaseDate,
    required this.actors,
    required this.directors,
    required this.writers,
    this.overview,
    this.tagline,
    this.comment,
  });

  @override
  List<Object?> get props => [
    title,
    genres,
    overview,
    releaseDate,
    tagline,
    actors,
    directors,
    writers,
    comment,
  ];
}
