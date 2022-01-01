import 'package:core/core.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/search.dart';

import 'tvshow_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTvShow])
void main() {
  late TvShowSearchNotifier provider;
  late MockSearchTvShow mockSearchTvShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTvShows = MockSearchTvShow();
    provider = TvShowSearchNotifier(searchTvShows: mockSearchTvShows)
      ..addListener(() {
        listenerCallCount += 1;
      });
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
  final tQuery = 'game';

  group('search tvShows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchTvShows.execute(tQuery))
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      provider.fetchTvShowSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchTvShows.execute(tQuery))
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      await provider.fetchTvShowSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, tTvShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTvShows.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvShowSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
