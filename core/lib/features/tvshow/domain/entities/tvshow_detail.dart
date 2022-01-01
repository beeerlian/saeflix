import 'package:core/features/tvshow/domain/entities/tvshow_genre.dart';
import 'package:equatable/equatable.dart';

class TvShowDetail extends Equatable {
  TvShowDetail({
    required this.posterPath,
    required this.id,
    required this.backdropPath,
    required this.voteAverage,
    required this.overview,
    required this.firstAirDate,
    required this.originCountry,
    required this.genres,
    required this.originalLanguage,
    required this.voteCount,
    required this.name,
    required this.originalName,
  });

  String? posterPath;
  double? popularity;
  int id;
  String? backdropPath;
  double? voteAverage;
  String? overview;
  String? firstAirDate;
  List<String>? originCountry;
  List<TvShowGenre>? genres;
  String? originalLanguage;
  int? voteCount;
  String? name;
  String? originalName;

  @override
  List<Object?> get props => [
        posterPath,
        popularity,
        id,
        backdropPath,
        voteAverage,
        voteCount,
        overview,
        firstAirDate,
        originCountry,
        originalLanguage,
        originalName,
        name,
        genres
      ];
}