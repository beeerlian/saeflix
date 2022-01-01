import 'package:core/features/tvshow/domain/usecases/remove_tvshow_watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveTvShowWatchList usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = RemoveTvShowWatchList(mockTvShowRepository);
  });

  test('should remove watchlist tvshow from repository', () async {
    // arrange
    when(mockTvShowRepository.removeTvShowWatchList(testTvShowDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTvShowDetail);
    // assert
    verify(mockTvShowRepository.removeTvShowWatchList(testTvShowDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
