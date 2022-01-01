import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/entities/tvshow_detail.dart';
import 'package:core/features/tvshow/domain/entities/tvshow_genre.dart';
import 'package:core/features/tvshow/domain/usecases/get_tvshow_detail.dart';
import 'package:core/features/tvshow/domain/usecases/get_tvshow_recommendation.dart';
import 'package:core/features/tvshow/domain/usecases/get_tvshow_watchlist_status.dart';
import 'package:core/features/tvshow/domain/usecases/get_watchlist_tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/remove_tvshow_watchlist.dart';
import 'package:core/features/tvshow/domain/usecases/save_tvshow_watchlist.dart';
import 'package:core/features/tvshow/presentation/bloc/tvshow_detail_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tvshow_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvShowDetail,
  GetTvShowRecommendation,
  GetWatchListTvShow,
  GetTvShowWatchListStatus,
  SaveTvShowWatchList,
  RemoveTvShowWatchList
])
void main() {
  late MockGetTvShowDetail mockGetTvShowDetail = MockGetTvShowDetail();
  late MockGetTvShowRecommendation mockGetTvShowRecommendation =
      MockGetTvShowRecommendation();
  late MockGetTvShowWatchListStatus mockGetWatchListStatus =
      MockGetTvShowWatchListStatus();
  late MockSaveTvShowWatchList mockSaveWatchlist = MockSaveTvShowWatchList();
  late MockRemoveTvShowWatchList mockRemoveWatchlist =
      MockRemoveTvShowWatchList();

  late TvShowDetailBloc tvShowDetailBloc;
  late TvShowRecommendationBloc tvShowRecommendationBloc;
  late TvShowWatchlistBloc tvShowWatchlistBloc;

  setUp(() {
    tvShowDetailBloc = TvShowDetailBloc(mockGetTvShowDetail);
    tvShowRecommendationBloc =
        TvShowRecommendationBloc(mockGetTvShowRecommendation);
    tvShowWatchlistBloc = TvShowWatchlistBloc(
        mockGetWatchListStatus, mockSaveWatchlist, mockRemoveWatchlist);
  });
  final testTvShow = TvShow(
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

  final int tId = 1;
  final testTvShowList = [testTvShow];

  final testTvShowDetail = TvShowDetail(
    posterPath: "posterpath.jpg",
    id: 1,
    backdropPath: "backdropPath",
    voteAverage: 2.0,
    overview: "overview",
    firstAirDate: "firstAirDate",
    originCountry: ["originCountry"],
    genres: [TvShowGenre(id: 1, name: "genre name")],
    originalLanguage: "originalLanguage",
    voteCount: 24,
    name: "name",
    originalName: "originalName",
  );

  group('TvShow Detail Bloc', () {
    test('Initial should be loading', () {
      expect(tvShowDetailBloc.state, TvShowDetailLoading());
    });

    blocTest<TvShowDetailBloc, TvShowDetailState>(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        build: () {
          when(mockGetTvShowDetail.execute(tId))
              .thenAnswer((_) async => Right(testTvShowDetail));
          return tvShowDetailBloc;
        },
        act: (bloc) => bloc.add(FetchTvShowDetail(tId)),
        expect: () =>
            [TvShowDetailLoading(), TvShowDetailLoaded(testTvShowDetail)],
        verify: (bloc) {
          verify(mockGetTvShowDetail.execute(tId));
        });

    blocTest<TvShowDetailBloc, TvShowDetailState>(
        'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
        build: () {
          when(mockGetTvShowDetail.execute(tId))
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return tvShowDetailBloc;
        },
        act: (bloc) => bloc.add(FetchTvShowDetail(tId)),
        expect: () =>
            [TvShowDetailLoading(), TvShowDetailFailure('Server Failure')],
        verify: (bloc) {
          verify(mockGetTvShowDetail.execute(tId));
        });
  });

  group('TvShow Recommendation', () {
    test('Initial should be loading', () {
      expect(tvShowRecommendationBloc.state, TvShowDetailLoading());
    });

    blocTest<TvShowRecommendationBloc, TvShowDetailState>(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        build: () {
          when(mockGetTvShowRecommendation.execute(tId))
              .thenAnswer((_) async => Right(testTvShowList));
          return tvShowRecommendationBloc;
        },
        act: (bloc) => bloc.add(FetchTvShowRecommendation(tId)),
        expect: () => [
              TvShowDetailLoading(),
              TvShowRecommendationsLoaded(testTvShowList)
            ],
        verify: (bloc) {
          verify(mockGetTvShowRecommendation.execute(tId));
        });

    blocTest<TvShowRecommendationBloc, TvShowDetailState>(
        'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
        build: () {
          when(mockGetTvShowRecommendation.execute(tId))
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return tvShowRecommendationBloc;
        },
        act: (bloc) => bloc.add(FetchTvShowRecommendation(tId)),
        expect: () => [
              TvShowDetailLoading(),
              TvShowRecommendationsFailure('Server Failure')
            ],
        verify: (bloc) {
          verify(mockGetTvShowRecommendation.execute(tId));
        });
  });

  // group('TvShow Watchlist Bloc', () {
  //   test('Initial should be loading', () {
  //     expect(tvShowWatchlistBloc.state, TvShowDetailLoading());
  //   });

  //   blocTest<TvShowWatchlistBloc, TvShowDetailState>(
  //       'Should emit success message when tvShow is saved to watchlist successfully',
  //       build: () {
  //         when(mockSaveWatchlist.execute(testTvShowDetail))
  //             .thenAnswer((_) async => Right("Success save to watchlist"));
  //         return tvShowWatchlistBloc;
  //       },
  //       act: (bloc) => bloc.add(AddTvShowWatchlist(testTvShowDetail)),
  //       expect: () => [
  //             AddedToWatchlistSuccess("Success save to watchlist"),
  //             IsAddedToWatchListStatus(true)
  //           ],
  //       verify: (bloc) {
  //         verify(mockSaveWatchlist.execute(testTvShowDetail));
  //       });

  //   // blocTest<TvShowWatchlistBloc, TvShowDetailState>(
  //   //     'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
  //   //     build: () {
  //   //       when(mockGetTvShowRecommendation.execute(tId))
  //   //           .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
  //   //       return tvShowRecommendationBloc;
  //   //     },
  //   //     act: (bloc) => bloc.add(FetchTvShowRecommendation(tId)),
  //   //     expect: () => [
  //   //           TvShowDetailLoading(),
  //   //           TvShowRecommendationsFailure('Server Failure')
  //   //         ],
  //   //     verify: (bloc) {
  //   //       verify(mockGetTvShowRecommendation.execute(tId));
  //   //     });
  // });
}
