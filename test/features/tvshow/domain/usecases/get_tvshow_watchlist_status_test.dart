import 'package:core/features/tvshow/domain/usecases/get_tvshow_watchlist_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvShowWatchListStatus usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetTvShowWatchListStatus(mockTvShowRepository);
  });

  test('should get tvshow watchlist status from repository', () async {
    // arrange
    when(mockTvShowRepository.getTvShowWatchListStatus(1))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
  });
}
