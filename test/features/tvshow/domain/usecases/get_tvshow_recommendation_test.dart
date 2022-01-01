import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_tvshow_recommendation.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvShowRepository mockTvShowRepository;
  late GetTvShowRecommendation usecase;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetTvShowRecommendation(mockTvShowRepository);
  });

  final tTvShows = <TvShow>[];
  final tId = 1;
  test(
      'should get list of tvshow recommendation from repository when execute function is called',
      () async {
    //arrange
    when(mockTvShowRepository.getTvShowRecommendation(tId))
        .thenAnswer((_) async => Right(tTvShows));
    //act
    final result = await usecase.execute(tId);
    //assert
    expect(result, Right(tTvShows));
  });
}
