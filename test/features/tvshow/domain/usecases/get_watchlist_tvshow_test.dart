

import 'package:core/features/tvshow/domain/usecases/get_watchlist_tvshow.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListTvShow usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetWatchListTvShow(mockTvShowRepository);
  });

  test('should get watchlist of tvshow from the repository', () async {
    // arrange
    when(mockTvShowRepository.getWatchListTvShow())
        .thenAnswer((_) async => Right(testTvShowList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testTvShowList));
  });
}
