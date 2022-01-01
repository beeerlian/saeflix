import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_top_rated_tvshow.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTvShow usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetTopRatedTvShow(mockTvShowRepository);
  });
  final tTvShows = <TvShow>[];

  test(
      'should get list of tvshow from the repository when execute function is called',
      () async {
    //arrage
    when(mockTvShowRepository.getTopRatedTvShow())
        .thenAnswer((_) async => Right(tTvShows));
    //act
    final result = await usecase.execute();
    //assert
    expect(result, Right(tTvShows));
  });
}
