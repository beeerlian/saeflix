import 'package:core/features/tvshow/domain/usecases/get_tvshow_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvShowDetail usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetTvShowDetail(mockTvShowRepository);
  });

  final tId = 1;

  test(
      'should get tvshow detail from repository when execute function is called',
      () async {
    //arrange
    when(mockTvShowRepository.getTvShowDetail(tId))
        .thenAnswer((_) async => Right(testTvShowDetail));
    //act
    final result = await usecase.execute(tId);
    //assert
    expect(result, Right(testTvShowDetail));
  });
}
