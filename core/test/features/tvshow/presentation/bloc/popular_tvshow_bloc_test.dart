import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/presentation/bloc/popular_tvshow_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'tvshow_list_bloc_test.mocks.dart';

void main() {
  MockGetPopularTvShow mockGetPopularTvShows = MockGetPopularTvShow();

  late AllPopularTvShowsBloc allPopularTvShowBloc;

  setUp(() {
    allPopularTvShowBloc = AllPopularTvShowsBloc(mockGetPopularTvShows);
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

  group('Popular TvShows Bloc', () {
    test('Initial should be loading', () {
      expect(allPopularTvShowBloc.state, PopularTvShowsLoading());
    });

    blocTest<AllPopularTvShowsBloc, PopularTvShowsState>(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        build: () {
          when(mockGetPopularTvShows.execute())
              .thenAnswer((_) async => Right(tTvShowList));
          return allPopularTvShowBloc;
        },
        act: (bloc) => bloc.add(FetchAllPopularTvShows()),
        expect: () =>
            [PopularTvShowsLoading(), PopularTvShowsLoaded(tTvShowList)],
        verify: (bloc) {
          verify(mockGetPopularTvShows.execute());
        });

    blocTest<AllPopularTvShowsBloc, PopularTvShowsState>(
        'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
        build: () {
          when(mockGetPopularTvShows.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return allPopularTvShowBloc;
        },
        act: (bloc) => bloc.add(FetchAllPopularTvShows()),
        expect: () =>
            [PopularTvShowsLoading(), PopularTvShowsFailed('Server Failure')],
        verify: (bloc) {
          verify(mockGetPopularTvShows.execute());
        });
  });
}
