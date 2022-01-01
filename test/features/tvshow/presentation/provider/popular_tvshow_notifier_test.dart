
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_popular_tvshow.dart';
import 'package:core/features/tvshow/presentation/provider/popular_tvshow_notifier.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tvshow_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTvShow])
void main() {
  late MockGetPopularTvShow mockGetPopularTvShows;
  late PopularTvShowsNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularTvShows = MockGetPopularTvShow();
    notifier = PopularTvShowsNotifier(getPopularTvShows: mockGetPopularTvShows)
      ..addListener(() {
        listenerCallCount++;
      });
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

  final tTvShowList = <TvShow>[tTvShow];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopularTvShows.execute())
        .thenAnswer((_) async => Right(tTvShowList));
    // act
    notifier.fetchPopularTvShows();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tvShows data when data is gotten successfully', () async {
    // arrange
    when(mockGetPopularTvShows.execute())
        .thenAnswer((_) async => Right(tTvShowList));
    // act
    await notifier.fetchPopularTvShows();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvShows, tTvShowList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopularTvShows.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchPopularTvShows();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
