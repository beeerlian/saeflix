import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies = MockGetWatchlistMovies();
  late AllWatchlistMoviesBloc allWatchlistMoviesBloc;

  setUp(() {
    allWatchlistMoviesBloc = AllWatchlistMoviesBloc(mockGetWatchlistMovies);
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
  group('Watchlist Movies Bloc', () {
    test('Initial should be loading', () {
      expect(allWatchlistMoviesBloc.state, WatchlistMoviesLoading());
    });

    blocTest<AllWatchlistMoviesBloc, WatchlistMoviesState>(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        build: () {
          when(mockGetWatchlistMovies.execute())
              .thenAnswer((_) async => Right(tMovieList));
          return allWatchlistMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchAllWatchlistMovies()),
        expect: () =>
            [WatchlistMoviesLoading(), WatchlistMoviesLoaded(tMovieList)],
        verify: (bloc) {
          verify(mockGetWatchlistMovies.execute());
        });

    blocTest<AllWatchlistMoviesBloc, WatchlistMoviesState>(
        'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
        build: () {
          when(mockGetWatchlistMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return allWatchlistMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchAllWatchlistMovies()),
        expect: () =>
            [WatchlistMoviesLoading(), WatchlistMoviesFailed('Server Failure')],
        verify: (bloc) {
          verify(mockGetWatchlistMovies.execute());
        });
  });
}
