import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/presentation/bloc/top_rated_tvshow_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'tvshow_list_bloc_test.mocks.dart';

void main() {
  late AllTopRatedTvShowsBloc allTopRatedTvShowsBloc;
  MockGetTopRatedTvShow mockGetTopRatedTvShows = MockGetTopRatedTvShow();

  setUp(() {
    allTopRatedTvShowsBloc = AllTopRatedTvShowsBloc(mockGetTopRatedTvShows);
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

  group('TopRated TvShows Bloc', () {
    test('Initial should be loading', () {
      expect(allTopRatedTvShowsBloc.state, TopRatedTvShowsLoading());
    });

    blocTest<AllTopRatedTvShowsBloc, TopRatedTvShowsState>(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        build: () {
          when(mockGetTopRatedTvShows.execute())
              .thenAnswer((_) async => Right(tTvShowList));
          return allTopRatedTvShowsBloc;
        },
        act: (bloc) => bloc.add(FetchAllTopRatedTvShows()),
        expect: () =>
            [TopRatedTvShowsLoading(), TopRatedTvShowsLoaded(tTvShowList)],
        verify: (bloc) {
          verify(mockGetTopRatedTvShows.execute());
        });

    blocTest<AllTopRatedTvShowsBloc, TopRatedTvShowsState>(
        'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
        build: () {
          when(mockGetTopRatedTvShows.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return allTopRatedTvShowsBloc;
        },
        act: (bloc) => bloc.add(FetchAllTopRatedTvShows()),
        expect: () =>
            [TopRatedTvShowsLoading(), TopRatedTvShowsFailed('Server Failure')],
        verify: (bloc) {
          verify(mockGetTopRatedTvShows.execute());
        });
  });
}
