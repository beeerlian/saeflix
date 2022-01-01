import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/presentation/bloc/watchlist_tvshow_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'tvshow_detail_bloc_test.mocks.dart';

void main() {
  late MockGetWatchListTvShow mockGetWatchlistTvShows =
      MockGetWatchListTvShow();
  late AllWatchlistTvShowsBloc allWatchlistTvShowsBloc;

  setUp(() {
    allWatchlistTvShowsBloc = AllWatchlistTvShowsBloc(mockGetWatchlistTvShows);
  });

  final tTvShowModel = TvShow(
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
  final tTvShowList = <TvShow>[tTvShowModel];
  group('Watchlist TvShows Bloc', () {
    test('Initial should be loading', () {
      expect(allWatchlistTvShowsBloc.state, WatchlistTvShowsLoading());
    });

    blocTest<AllWatchlistTvShowsBloc, WatchlistTvShowsState>(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        build: () {
          when(mockGetWatchlistTvShows.execute())
              .thenAnswer((_) async => Right(tTvShowList));
          return allWatchlistTvShowsBloc;
        },
        act: (bloc) => bloc.add(FetchAllWatchlistTvShows()),
        expect: () =>
            [WatchlistTvShowsLoading(), WatchlistTvShowsLoaded(tTvShowList)],
        verify: (bloc) {
          verify(mockGetWatchlistTvShows.execute());
        });

    blocTest<AllWatchlistTvShowsBloc, WatchlistTvShowsState>(
        'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
        build: () {
          when(mockGetWatchlistTvShows.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return allWatchlistTvShowsBloc;
        },
        act: (bloc) => bloc.add(FetchAllWatchlistTvShows()),
        expect: () => [
              WatchlistTvShowsLoading(),
              WatchlistTvShowsFailed('Server Failure')
            ],
        verify: (bloc) {
          verify(mockGetWatchlistTvShows.execute());
        });
  });
}
