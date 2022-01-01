import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_tvshow_detail.dart';
import 'package:core/features/tvshow/domain/usecases/get_tvshow_recommendation.dart';
import 'package:core/features/tvshow/domain/usecases/get_tvshow_watchlist_status.dart';
import 'package:core/features/tvshow/domain/usecases/remove_tvshow_watchlist.dart';
import 'package:core/features/tvshow/domain/usecases/save_tvshow_watchlist.dart';
import 'package:core/features/tvshow/presentation/provider/tvshow_detail_notifier.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'tvshow_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvShowDetail,
  GetTvShowRecommendation,
  GetTvShowWatchListStatus,
  SaveTvShowWatchList,
  RemoveTvShowWatchList
])
void main() {
  late TvShowDetailNotifier provider;
  late MockGetTvShowDetail mockGetTvShowDetail;
  late MockGetTvShowRecommendation mockGetTvShowRecommendations;
  late MockGetTvShowWatchListStatus mockGetWatchlistStatus;
  late MockSaveTvShowWatchList mockSaveWatchlist;
  late MockRemoveTvShowWatchList mockRemoveWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvShowDetail = MockGetTvShowDetail();
    mockGetTvShowRecommendations = MockGetTvShowRecommendation();
    mockGetWatchlistStatus = MockGetTvShowWatchListStatus();
    mockSaveWatchlist = MockSaveTvShowWatchList();
    mockRemoveWatchlist = MockRemoveTvShowWatchList();
    provider = TvShowDetailNotifier(
      getTvShowDetail: mockGetTvShowDetail,
      getTvShowRecommendation: mockGetTvShowRecommendations,
      getTvShowWatchListStatus: mockGetWatchlistStatus,
      removeTvShowWatchList: mockRemoveWatchlist,
      saveTvShowWatchList: mockSaveWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

  final tTvShow = TvShow(
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
  final tTvShows = <TvShow>[tTvShow];

  void _arrangeUsecase() {
    when(mockGetTvShowDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvShowDetail));
    when(mockGetTvShowRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTvShows));
  }

  group('Get TvShow Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvShowDetail(tId);
      // assert
      verify(mockGetTvShowDetail.execute(tId));
      verify(mockGetTvShowRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchTvShowDetail(tId);
      // assert
      expect(provider.tvshowState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tvShow when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvShowDetail(tId);
      // assert
      expect(provider.tvshowState, RequestState.Loaded);
      expect(provider.tvshow, testTvShowDetail);
      expect(listenerCallCount, 3);
    });

    test(
        'should change recommendation tvShows when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvShowDetail(tId);
      // assert
      expect(provider.tvshowState, RequestState.Loaded);
      expect(provider.tvshowRecommendations, tTvShows);
    });
  });

  group('Get TvShow Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvShowDetail(tId);
      // assert
      verify(mockGetTvShowRecommendations.execute(tId));
      expect(provider.tvshowRecommendations, tTvShows);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvShowDetail(tId);
      // assert
      expect(provider.tvshowRecommendationsState, RequestState.Loaded);
      expect(provider.tvshowRecommendations, tTvShows);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTvShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvShowDetail));
      when(mockGetTvShowRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchTvShowDetail(tId);
      // assert
      expect(provider.tvshowRecommendationsState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.addToWatchlistStatus, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTvShowDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatus.execute(testTvShowDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testTvShowDetail);
      // assert
      verify(mockSaveWatchlist.execute(testTvShowDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlist.execute(testTvShowDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatus.execute(testTvShowDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(testTvShowDetail);
      // assert
      verify(mockRemoveWatchlist.execute(testTvShowDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTvShowDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testTvShowDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testTvShowDetail);
      // assert
      verify(mockGetWatchlistStatus.execute(testTvShowDetail.id));
      expect(provider.addToWatchlistStatus, true);
      expect(provider.watchListmessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTvShowDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testTvShowDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(testTvShowDetail);
      // assert
      expect(provider.watchListmessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvShowDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTvShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTvShows));
      // act
      await provider.fetchTvShowDetail(tId);
      // assert
      expect(provider.tvshowState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
