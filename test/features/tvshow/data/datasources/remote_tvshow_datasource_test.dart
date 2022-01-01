import 'dart:convert';
import 'dart:io';

import 'package:core/features/tvshow/data/datasources/remote_tvshow_datasource.dart';
import 'package:core/features/tvshow/data/models/tvshow_detail_model.dart';
import 'package:core/features/tvshow/data/models/tvshows_response.dart';
import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';
import '../../../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvShowRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvShowRemoteDataSourceImpl(mockHttpClient);
  });

  group('get now airing tv show', () {
    final tTvShowList = TvShowResponse.fromJson(
            jsonDecode(readJson('dummy_data/tvshow_now_airing.json')))
        .tvShowList;

    test('should return list of Tv Show Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                  readJson('dummy_data/tvshow_now_airing.json'), 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));
      // act
      final result = await dataSource.getNowPlayingTvShow();
      // assert
      expect(result, equals(tTvShowList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getNowPlayingTvShow();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get popular tv show', () {
    final tTvShowList = TvShowResponse.fromJson(
            jsonDecode(readJson('dummy_data/popular_tvshow.json')))
        .tvShowList;

    test('should return list of movies when response is success (200)',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                  readJson('dummy_data/popular_tvshow.json'), 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));
      // act
      final result = await dataSource.getPopularTvShow();
      // assert
      expect(result, tTvShowList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularTvShow();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated Tv Show', () {
    final tTvShowList = TvShowResponse.fromJson(
            json.decode(readJson('dummy_data/top_rated_tvshow.json')))
        .tvShowList;

    test('should return list of tvshows when response is success (200)',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                  readJson('dummy_data/top_rated_tvshow.json'), 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));
      // act
      final result = await dataSource.getTopRatedTvShow();
      // assert
      expect(result, tTvShowList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedTvShow();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Tv Show Recommendation', () {
    final tTvShowList = TvShowResponse.fromJson(
            json.decode(readJson('dummy_data/tvshow_recommendations.json')))
        .tvShowList;
    final tId = 1;
    test('should return list of tvshows when response is success (200)',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tvshow_recommendations.json'), 200));
      // act
      final result = await dataSource.getTvShowRecommendation(tId);
      // assert
      expect(result, tTvShowList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvShowRecommendation(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tv show', () {
    final tTvShowList = TvShowResponse.fromJson(
            json.decode(readJson('dummy_data/search_game_tvshow.json')))
        .tvShowList;
    final tQuery = "game";
    test('should return list of tvshows when response is success (200)',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/search_game_tvshow.json'), 200));
      // act
      final result = await dataSource.searchTvShow(tQuery);
      // assert
      expect(result, tTvShowList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchTvShow(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tvshow detail', () {
    final tTvShowDetail = TvShowDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tvshow_detail.json')));
    final tId = 1399;
    test('should return tvshow detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                  readJson('dummy_data/tvshow_detail.json'), 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));
      // act
      final result = await dataSource.getTvShowDetail(tId);
      // assert
      expect(result, equals(tTvShowDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvShowDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
