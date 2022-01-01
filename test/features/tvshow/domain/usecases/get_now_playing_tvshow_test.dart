import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_now_playing_tvshow.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTvShow usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetNowPlayingTvShow(mockTvShowRepository);
  });

  final tTvShows = <TvShow>[];

  test('should get list of tvShow from the repository', () async {
    //arrange
    when(mockTvShowRepository.getNowPlayingTvShow())
        .thenAnswer((_) async => Right(tTvShows));
    //act
    final result = await usecase.execute();
    //assert
    expect(result, Right(tTvShows));
  });
}
