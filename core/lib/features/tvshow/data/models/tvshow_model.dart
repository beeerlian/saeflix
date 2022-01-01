import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:equatable/equatable.dart';

class TvShowModel extends Equatable {
  TvShowModel({
    required this.posterPath,
    required this.id,
    required this.backdropPath,
    required this.voteAverage,
    required this.overview,
    required this.firstAirDate,
    required this.originCountry,
    required this.genreIds,
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
  List<int>? genreIds;
  String? originalLanguage;
  int? voteCount;
  String? name;
  String? originalName;

  factory TvShowModel.fromJson(Map<String, dynamic> json) {
    return TvShowModel(
        posterPath: json["poster_path"],
        id: json["id"],
        backdropPath: json["backdrop_path"],
        voteAverage: (json["vote_average"]).toDouble(),
        overview: json["overview"],
        firstAirDate: json["first_air_date"].toString(),
        originCountry:
            List<String>.from((json["origin_country"] as List).map((e) => e))
                .toList(),
        genreIds:
            List<int>.from((json["genre_ids"] as List).map((e) => e)).toList(),
        originalLanguage: json["original_language"],
        voteCount: json["vote_count"],
        name: json["name"],
        originalName: json["original_name"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "poster_path": posterPath,
      "backdrop_path": backdropPath,
      "vote_average": voteAverage,
      "overview": overview,
      "first_air-date": firstAirDate,
      "origin_country": originCountry,
      "genre_ids": genreIds,
      "original_language": originalLanguage,
      "vote_count": voteCount,
      "name": name,
      "original_name": originalName
    };
  }

  TvShow toEntity() {
    return TvShow(
        id: id,
        posterPath: posterPath,
        backdropPath: backdropPath,
        voteAverage: voteAverage,
        overview: overview,
        firstAirDate: firstAirDate,
        originCountry: originCountry,
        genreIds: genreIds,
        originalLanguage: originalLanguage,
        voteCount: voteCount,
        name: name,
        originalName: originalName);
  }

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
        genreIds
      ];
}
