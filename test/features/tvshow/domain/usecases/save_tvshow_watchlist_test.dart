

import 'package:core/features/tvshow/domain/usecases/save_tvshow_watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveTvShowWatchList usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = SaveTvShowWatchList(mockTvShowRepository);
  });

  test('should save tvshow to the repository', () async {
    // arrange
    when(mockTvShowRepository.saveTvShowWatchList(testTvShowDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvShowDetail);
    // assert
    verify(mockTvShowRepository.saveTvShowWatchList(testTvShowDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
