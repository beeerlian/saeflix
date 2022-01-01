import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_now_playing_tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_popular_tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_top_rated_tvshow.dart';
import 'package:core/features/tvshow/presentation/bloc/tvshow_list_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tvshow_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvShow, GetPopularTvShow, GetTopRatedTvShow])
void main() {
  MockGetNowPlayingTvShow mockGetNowPlayingTvShow = MockGetNowPlayingTvShow();
  MockGetPopularTvShow mockGetPopularTvShow = MockGetPopularTvShow();
  MockGetTopRatedTvShow mockGetTopRatedTvShow = MockGetTopRatedTvShow();

  late NowPlayingTvShowBloc nowPlayingTvShowBloc;
  late PopularTvShowBloc popularTvShowBloc;
  late TopRatedTvShowBloc topRatedTvShowBloc;
  setUp(() {
    nowPlayingTvShowBloc = NowPlayingTvShowBloc(mockGetNowPlayingTvShow);
    popularTvShowBloc = PopularTvShowBloc(mockGetPopularTvShow);
    topRatedTvShowBloc = TopRatedTvShowBloc(mockGetTopRatedTvShow);
  });

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

  final tTvShowList = [tTvShow];

  group('Now Playing TvShow Bloc', () {
    test('Initial should be loading', () {
      expect(nowPlayingTvShowBloc.state, NowPlayingTvShowListLoading());
    });

    blocTest<NowPlayingTvShowBloc, TvShowListState>(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        build: () {
          when(mockGetNowPlayingTvShow.execute())
              .thenAnswer((_) async => Right(tTvShowList));
          return nowPlayingTvShowBloc;
        },
        act: (bloc) => bloc.add(FetchNowPlayingTvShows()),
        expect: () => [
              NowPlayingTvShowListLoading(),
              NowPlayingTvShowListLoaded(tTvShowList)
            ],
        verify: (bloc) {
          verify(mockGetNowPlayingTvShow.execute());
        });

    blocTest<NowPlayingTvShowBloc, TvShowListState>(
        'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
        build: () {
          when(mockGetNowPlayingTvShow.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return nowPlayingTvShowBloc;
        },
        act: (bloc) => bloc.add(FetchNowPlayingTvShows()),
        expect: () => [
              NowPlayingTvShowListLoading(),
              NowPlayingTvShowListHasError('Server Failure')
            ],
        verify: (bloc) {
          verify(mockGetNowPlayingTvShow.execute());
        });
  });

  group('Popular TvShow Bloc', () {
    test('Initial should be loading', () {
      expect(popularTvShowBloc.state, PopularTvShowListLoading());
    });

    blocTest<PopularTvShowBloc, TvShowListState>(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        build: () {
          when(mockGetPopularTvShow.execute())
              .thenAnswer((_) async => Right(tTvShowList));
          return popularTvShowBloc;
        },
        act: (bloc) => bloc.add(FetchPopularTvShows()),
        expect: () =>
            [PopularTvShowListLoading(), PopularTvShowListLoaded(tTvShowList)],
        verify: (bloc) {
          verify(mockGetPopularTvShow.execute());
        });

    blocTest<PopularTvShowBloc, TvShowListState>(
        'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
        build: () {
          when(mockGetPopularTvShow.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return popularTvShowBloc;
        },
        act: (bloc) => bloc.add(FetchPopularTvShows()),
        expect: () => [
              PopularTvShowListLoading(),
              PopularTvShowListHasError('Server Failure')
            ],
        verify: (bloc) {
          verify(mockGetPopularTvShow.execute());
        });
  });

  group('Top Rated TvShow Bloc', () {
    test('Initial should be loading', () {
      expect(topRatedTvShowBloc.state, TopRatedTvShowListLoading());
    });

    blocTest<TopRatedTvShowBloc, TvShowListState>(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        build: () {
          when(mockGetTopRatedTvShow.execute())
              .thenAnswer((_) async => Right(tTvShowList));
          return topRatedTvShowBloc;
        },
        act: (bloc) => bloc.add(FetchTopRatedTvShows()),
        expect: () => [
              TopRatedTvShowListLoading(),
              TopRatedTvShowListLoaded(tTvShowList)
            ],
        verify: (bloc) {
          verify(mockGetTopRatedTvShow.execute());
        });

    blocTest<TopRatedTvShowBloc, TvShowListState>(
        'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
        build: () {
          when(mockGetTopRatedTvShow.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return topRatedTvShowBloc;
        },
        act: (bloc) => bloc.add(FetchTopRatedTvShows()),
        expect: () => [
              TopRatedTvShowListLoading(),
              TopRatedTvShowListHasError('Server Failure')
            ],
        verify: (bloc) {
          verify(mockGetTopRatedTvShow.execute());
        });
  });
}
