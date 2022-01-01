import 'dart:io';

import 'package:core/features/tvshow/data/models/tvshow_detail_model.dart';
import 'package:core/features/tvshow/data/models/tvshow_genre_model.dart';
import 'package:core/features/tvshow/data/models/tvshow_model.dart';
import 'package:core/features/tvshow/data/repositories/tvshow_repository_impl.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late TvShowRepositoryImpl repository;
  late MockTvShowLocalDataSource mockLocalDataSource;
  late MockTvShowRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockTvShowLocalDataSource();
    mockRemoteDataSource = MockTvShowRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TvShowRepositoryImpl(
        remoteDatasource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  final tTvShowModel = TvShowModel(
    id: 1,
    posterPath: "posterPath",
    backdropPath: "backdropPath",
    voteAverage: 2.0,
    overview: "overview",
    firstAirDate: "firstAirDate",
    originCountry: ["originCountry"],
    genreIds: [1, 2],
    originalLanguage: "originalLanguage",
    voteCount: 24,
    name: "name",
    originalName: "originalName",
  );

  final tTvShowModelList = <TvShowModel>[tTvShowModel];
  final tTvShowList = <TvShow>[testTvShow];

  group('Now Playing TvShow', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });
    test('Should check is the device online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getNowPlayingTvShow())
          .thenAnswer((_) async => []);
      //act
      await repository.getNowPlayingTvShow();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTvShow())
          .thenAnswer((_) async => tTvShowModelList);
      // act
      final result = await repository.getNowPlayingTvShow();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTvShow());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvShowList);
    });

    test(
        'Should cache data locally when the call to remote data source is successful',
        () async {
      //arrange
      when(mockRemoteDataSource.getNowPlayingTvShow())
          .thenAnswer((_) async => tTvShowModelList);
      //act
      await repository.getNowPlayingTvShow();
      //assert
      verify(mockRemoteDataSource.getNowPlayingTvShow());
      verify(mockLocalDataSource.cacheNowPlayingTvShows([testTvShowCache]));
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTvShow())
          .thenThrow(ServerException());
      // act
      final result = await repository.getNowPlayingTvShow();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTvShow());
      expect(result, equals(Left(ServerFailure(''))));
    });
  });

  group('Popular TvSHow', () {
    test('should return tvshow list when call to data source is success',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvShow())
          .thenAnswer((_) async => tTvShowModelList);
      // act
      final result = await repository.getPopularTvShow();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvShowList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvShow())
          .thenThrow(ServerException());
      // act
      final result = await repository.getPopularTvShow();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvShow())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularTvShow();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Tv Show', () {
    test('should return tvshow list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvShow())
          .thenAnswer((_) async => tTvShowModelList);
      // act
      final result = await repository.getTopRatedTvShow();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvShowList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvShow())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTvShow();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvShow())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedTvShow();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get TvShow Detail', () {
    final tId = 1;
    final tTvShowResponse = TvShowDetailResponse(
      backdropPath: "backdropPath",
      episodeRunTime: [1, 2, 3],
      firstAirDate: "firstAirDate",
      genres: [TvShowGenreModel(id: 1, name: 'genre name')],
      homepage: "homepage",
      id: 1,
      inProduction: true,
      languages: ["languages"],
      lastAirDate: "lastAirDate",
      name: "name",
      nextEpisodeToAir: "nextEpisodeToAir",
      numberOfEpisodes: 3,
      numberOfSeasons: 1,
      originCountry: ["originCountry"],
      originalLanguage: "originalLanguage",
      originalName: "originalName",
      overview: "overview",
      popularity: 2.1,
      posterPath: "posterpath.jpg",
      status: "status",
      tagline: "tagline",
      type: "type",
      voteAverage: 2.0,
      voteCount: 24,
    );
    test(
        'should return TvShow data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvShowDetail(tId))
          .thenAnswer((_) async => tTvShowResponse);
      // act
      final result = await repository.getTvShowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvShowDetail(tId));
      expect(result, equals(Right(testTvShowDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvShowDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvShowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvShowDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvShowDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvShowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvShowDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });
  group('Get TvShow Recommendations', () {
    final tTvShowList = <TvShowModel>[];
    final tId = 1;

    test('should return data (tvshow list) when the call is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvShowRecommendation(tId))
          .thenAnswer((_) async => tTvShowList);
      // act
      final result = await repository.getTvShowRecommendation(tId);
      // assert
      verify(mockRemoteDataSource.getTvShowRecommendation(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvShowList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvShowRecommendation(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvShowRecommendation(tId);
      // assertbuild runner
      verify(mockRemoteDataSource.getTvShowRecommendation(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvShowRecommendation(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvShowRecommendation(tId);
      // assert
      verify(mockRemoteDataSource.getTvShowRecommendation(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Seach TvShows', () {
    final tQuery = 'game';

    test('should return tvshow list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvShow(tQuery))
          .thenAnswer((_) async => tTvShowModelList);
      // act
      final result = await repository.searchTvShow(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvShowList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvShow(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchTvShow(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvShow(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchTvShow(tQuery);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });
  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getTvShowById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.getTvShowWatchListStatus(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of TvShows', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTvShows())
          .thenAnswer((_) async => [testTvShowTable]);
      // act
      final result = await repository.getWatchListTvShow();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvShow]);
    });
  });
}
