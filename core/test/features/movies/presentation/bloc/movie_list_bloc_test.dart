import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:core/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:core/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
])
void main() {
  late NowPlayingMoviesBloc nowPlayingMoviesBloc;
  late PopularMoviesBloc popularMoviesBloc;
  late TopRatedMoviesBloc topRatedMoviesBloc;

  MockGetNowPlayingMovies mockGetNowPlayingMovies = MockGetNowPlayingMovies();
  MockGetPopularMovies mockGetPopularMovies = MockGetPopularMovies();
  MockGetTopRatedMovies mockGetTopRatedMovies = MockGetTopRatedMovies();

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    mockGetPopularMovies = MockGetPopularMovies();

    nowPlayingMoviesBloc = NowPlayingMoviesBloc(mockGetNowPlayingMovies);
    popularMoviesBloc = PopularMoviesBloc(mockGetPopularMovies);
    topRatedMoviesBloc = TopRatedMoviesBloc(mockGetTopRatedMovies);
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
  group('Now Playing Movies Bloc', () {
    test('Initial should be loading', () {
      expect(nowPlayingMoviesBloc.state, NowPlayingMovieListLoading());
    });

    blocTest<NowPlayingMoviesBloc, MovieListState>(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        build: () {
          when(mockGetNowPlayingMovies.execute())
              .thenAnswer((_) async => Right(tMovieList));
          return nowPlayingMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchNowPlayingMovies()),
        expect: () => [
              NowPlayingMovieListLoading(),
              NowPlayingMovieListLoaded(tMovieList)
            ],
        verify: (bloc) {
          verify(mockGetNowPlayingMovies.execute());
        });

    blocTest<NowPlayingMoviesBloc, MovieListState>(
        'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
        build: () {
          when(mockGetNowPlayingMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return nowPlayingMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchNowPlayingMovies()),
        expect: () => [
              NowPlayingMovieListLoading(),
              NowPlayingMovieListHasError('Server Failure')
            ],
        verify: (bloc) {
          verify(mockGetNowPlayingMovies.execute());
        });
  });

  group('Popular Movies Bloc', () {
    test('Initial should be loading', () {
      expect(popularMoviesBloc.state, PopularMovieListLoading());
    });

    blocTest<PopularMoviesBloc, MovieListState>(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        build: () {
          when(mockGetPopularMovies.execute())
              .thenAnswer((_) async => Right(tMovieList));
          return popularMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchPopularMovies()),
        expect: () =>
            [PopularMovieListLoading(), PopularMovieListLoaded(tMovieList)],
        verify: (bloc) {
          verify(mockGetPopularMovies.execute());
        });

    blocTest<PopularMoviesBloc, MovieListState>(
        'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
        build: () {
          when(mockGetPopularMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return popularMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchPopularMovies()),
        expect: () => [
              PopularMovieListLoading(),
              PopularMovieListHasError('Server Failure')
            ],
        verify: (bloc) {
          verify(mockGetPopularMovies.execute());
        });
  });

  group('Top Rated Movies Bloc', () {
    test('Initial should be loading', () {
      expect(topRatedMoviesBloc.state, TopRatedMovieListLoading());
    });

    blocTest<TopRatedMoviesBloc, MovieListState>(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        build: () {
          when(mockGetTopRatedMovies.execute())
              .thenAnswer((_) async => Right(tMovieList));
          return topRatedMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchTopRatedMovies()),
        expect: () =>
            [TopRatedMovieListLoading(), TopRatedMovieListLoaded(tMovieList)],
        verify: (bloc) {
          verify(mockGetTopRatedMovies.execute());
        });

    blocTest<TopRatedMoviesBloc, MovieListState>(
        'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
        build: () {
          when(mockGetTopRatedMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return topRatedMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchTopRatedMovies()),
        expect: () => [
              TopRatedMovieListLoading(),
              TopRatedMovieListHasError('Server Failure')
            ],
        verify: (bloc) {
          verify(mockGetTopRatedMovies.execute());
        });
  });
}
