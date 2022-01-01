import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:core/features/movies/domain/usecases/get_movie_recommendations.dart';
import 'package:core/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:core/features/movies/domain/usecases/get_watchlist_status.dart';
import 'package:core/features/movies/domain/usecases/remove_watchlist.dart';
import 'package:core/features/movies/domain/usecases/save_watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchlistMovies,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist
])
void main() {
  late MockGetMovieDetail mockGetMovieDetail = MockGetMovieDetail();
  late MockGetMovieRecommendations mockGetMovieRecommendations =
      MockGetMovieRecommendations();
  late MockGetWatchListStatus mockGetWatchListStatus = MockGetWatchListStatus();
  late MockSaveWatchlist mockSaveWatchlist = MockSaveWatchlist();
  late MockRemoveWatchlist mockRemoveWatchlist = MockRemoveWatchlist();

  late MovieDetailBloc movieDetailBloc;
  late MovieRecommendationBloc movieRecommendationBloc;
  late MovieWatchlistBloc movieWatchlistBloc;

  setUp(() {
    movieDetailBloc = MovieDetailBloc(mockGetMovieDetail);
    movieRecommendationBloc =
        MovieRecommendationBloc(mockGetMovieRecommendations);
    movieWatchlistBloc = MovieWatchlistBloc(
        mockGetWatchListStatus, mockSaveWatchlist, mockRemoveWatchlist);
  });

  final testMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  final int tId = 557;

  final testMovie = Movie(
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

  final testMovieList = [testMovie];
  group('Movie Detail Bloc', () {
    test('Initial should be loading', () {
      expect(movieDetailBloc.state, MovieDetailLoading());
    });

    blocTest<MovieDetailBloc, MovieDetailState>(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        build: () {
          when(mockGetMovieDetail.execute(tId))
              .thenAnswer((_) async => Right(testMovieDetail));
          return movieDetailBloc;
        },
        act: (bloc) => bloc.add(FetchMovieDetail(tId)),
        expect: () =>
            [MovieDetailLoading(), MovieDetailLoaded(testMovieDetail)],
        verify: (bloc) {
          verify(mockGetMovieDetail.execute(tId));
        });

    blocTest<MovieDetailBloc, MovieDetailState>(
        'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
        build: () {
          when(mockGetMovieDetail.execute(tId))
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return movieDetailBloc;
        },
        act: (bloc) => bloc.add(FetchMovieDetail(tId)),
        expect: () =>
            [MovieDetailLoading(), MovieDetailFailure('Server Failure')],
        verify: (bloc) {
          verify(mockGetMovieDetail.execute(tId));
        });
  });

  group('Movie Recommendation', () {
    test('Initial should be loading', () {
      expect(movieRecommendationBloc.state, MovieDetailLoading());
    });

    blocTest<MovieRecommendationBloc, MovieDetailState>(
        'Should emit [Loading, Loaded] when data is gotten successfully',
        build: () {
          when(mockGetMovieRecommendations.execute(tId))
              .thenAnswer((_) async => Right(testMovieList));
          return movieRecommendationBloc;
        },
        act: (bloc) => bloc.add(FetchMovieRecommendation(tId)),
        expect: () =>
            [MovieDetailLoading(), MovieRecommendationsLoaded(testMovieList)],
        verify: (bloc) {
          verify(mockGetMovieRecommendations.execute(tId));
        });

    blocTest<MovieRecommendationBloc, MovieDetailState>(
        'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
        build: () {
          when(mockGetMovieRecommendations.execute(tId))
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return movieRecommendationBloc;
        },
        act: (bloc) => bloc.add(FetchMovieRecommendation(tId)),
        expect: () => [
              MovieDetailLoading(),
              MovieRecommendationsFailure('Server Failure')
            ],
        verify: (bloc) {
          verify(mockGetMovieRecommendations.execute(tId));
        });
  });

  // group('Movie Watchlist Bloc', () {
  //   test('Initial should be loading', () {
  //     expect(movieWatchlistBloc.state, MovieDetailLoading());
  //   });

  //   blocTest<MovieWatchlistBloc, MovieDetailState>(
  //       'Should emit success message when movie is saved to watchlist successfully',
  //       build: () {
  //         when(mockSaveWatchlist.execute(testMovieDetail))
  //             .thenAnswer((_) async => Right("Success save to watchlist"));
  //         return movieWatchlistBloc;
  //       },
  //       act: (bloc) => bloc.add(AddMovieWatchlist(testMovieDetail)),
  //       expect: () => [
  //             AddedToWatchlistSuccess("Success save to watchlist"),
  //             IsAddedToWatchListStatus(true)
  //           ],
  //       verify: (bloc) {
  //         verify(mockSaveWatchlist.execute(testMovieDetail));
  //       });

  //   // blocTest<MovieWatchlistBloc, MovieDetailState>(
  //   //     'Should emit [Loading, Failure] when get data is unsuccessful/ failed ',
  //   //     build: () {
  //   //       when(mockGetMovieRecommendations.execute(tId))
  //   //           .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
  //   //       return movieRecommendationBloc;
  //   //     },
  //   //     act: (bloc) => bloc.add(FetchMovieRecommendation(tId)),
  //   //     expect: () => [
  //   //           MovieDetailLoading(),
  //   //           MovieRecommendationsFailure('Server Failure')
  //   //         ],
  //   //     verify: (bloc) {
  //   //       verify(mockGetMovieRecommendations.execute(tId));
  //   //     });
  // });
}
