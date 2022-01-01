import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_bloc_test.mocks.dart';

void main() {
  late AllTopRatedMoviesBloc allTopRatedMoviesBloc;
  MockGetTopRatedMovies mockGetTopRatedMovies = MockGetTopRatedMovies();

  setUp(() {
    allTopRatedMoviesBloc = AllTopRatedMoviesBloc(mockGetTopRatedMovies);
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];

  group('TopRated Movies Bloc', () {
    test('Initial should be loading', () {
      expect(allTopRatedMoviesBloc.state, TopRatedMoviesLoading());
    });

    blocTest<AllTopRatedMoviesBloc, TopRatedMoviesState>(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        build: () {
          when(mockGetTopRatedMovies.execute())
              .thenAnswer((_) async => Right(tMovieList));
          return allTopRatedMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchAllTopRatedMovies()),
        expect: () =>
            [TopRatedMoviesLoading(), TopRatedMoviesLoaded(tMovieList)],
        verify: (bloc) {
          verify(mockGetTopRatedMovies.execute());
        });

    blocTest<AllTopRatedMoviesBloc, TopRatedMoviesState>(
        'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
        build: () {
          when(mockGetTopRatedMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return allTopRatedMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchAllTopRatedMovies()),
        expect: () =>
            [TopRatedMoviesLoading(), TopRatedMoviesFailed('Server Failure')],
        verify: (bloc) {
          verify(mockGetTopRatedMovies.execute());
        });
  });
}
