import 'package:core/features/tvshow/data/models/tvshow_model.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvShowModel = TvShowModel(
    id: 1,
    posterPath: "posterPath",
    backdropPath: "backdropPath",
    voteAverage: 2.1,
    overview: "overview",
    firstAirDate: "firstAirDate",
    originCountry: ["originCountry"],
    genreIds: [1, 2, 3],
    originalLanguage: "originalLanguage",
    voteCount: 200,
    name: "name",
    originalName: "originalName",
  );

  final tTvShow = TvShow(
    id: 1,
    posterPath: "posterPath",
    backdropPath: "backdropPath",
    voteAverage: 2.1,
    overview: "overview",
    firstAirDate: "firstAirDate",
    originCountry: ["originCountry"],
    genreIds: [1, 2, 3],
    originalLanguage: "originalLanguage",
    voteCount: 200,
    name: "name",
    originalName: "originalName",
  );

  test('should be a subclass of TvShow Entity', () async {
    final result = tTvShowModel.toEntity();
    expect(result, tTvShow);
  });
}
