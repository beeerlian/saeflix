import 'dart:convert';

import 'package:core/features/tvshow/data/models/tvshow_model.dart';
import 'package:core/features/tvshow/data/models/tvshows_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../json_reader.dart';

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

  final tTvShowResponseModel =
      TvShowResponse(tvShowList: <TvShowModel>[tTvShowModel]);

  test('should return a valid response model from the json', () async {
    //arrange
    final Map<String, dynamic> jsonMap =
        jsonDecode(readJson('dummy_data/tvshow_now_airing.json'));
    //act
    final result = TvShowResponse.fromJson(jsonMap);
    //assert
    expect(result, tTvShowResponseModel);
  });

  test('should return a json map containng proper data', () async {
    //arrange

    //act
    final result = tTvShowResponseModel.toJson();
    //assert
    final expectedJson = {
      "results": [
        {
          "id": 1,
          "poster_path": "posterPath",
          "backdrop_path": "backdropPath",
          "vote_average": 2.1,
          "overview": "overview",
          "first_air-date": "firstAirDate",
          "origin_country": ["originCountry"],
          "genre_ids": [1, 2, 3],
          "original_language": "originalLanguage",
          "vote_count": 200,
          "name": "name",
          "original_name": "originalName"
        }
      ]
    };
    expect(result, expectedJson);
  });
}
