import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/search.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvShowRepository mockTvShowRepository;
  late SearchTvShow usecase;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = SearchTvShow(mockTvShowRepository);
  });

  final tTvShows = <TvShow>[];
  final tQuery = 'query';
  test(
      'should get list of searched tvshow when the execute function is called ',
      () async {
    //arrage
    when(mockTvShowRepository.searchTvShow(tQuery))
        .thenAnswer((_) async => Right(tTvShows));
    //act
    final result = await usecase.execute(tQuery);
    //assert
    expect(result, Right(tTvShows));
  });
}
