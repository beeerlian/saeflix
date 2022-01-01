import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_top_rated_tvshow.dart';
import 'package:core/features/tvshow/presentation/provider/toprated_tvshow_notifier.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tvshow_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedTvShow])
void main() {
  late MockGetTopRatedTvShow mockGetTopRatedTvShows;
  late TopRatedTvShowsNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedTvShows = MockGetTopRatedTvShow();
    notifier =
        TopRatedTvShowsNotifier(getTopRatedTvShows: mockGetTopRatedTvShows)
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
    when(mockGetTopRatedTvShows.execute())
        .thenAnswer((_) async => Right(tTvShowList));
    // act
    notifier.fetchTopRatedTvShows();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tvShow data when data is gotten successfully', () async {
    // arrange
    when(mockGetTopRatedTvShows.execute())
        .thenAnswer((_) async => Right(tTvShowList));
    // act
    await notifier.fetchTopRatedTvShows();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvShows, tTvShowList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTopRatedTvShows.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchTopRatedTvShows();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
