import 'package:bloc_test/bloc_test.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/features/tvshow/domain/usecases/search_tvshow.dart';
import 'package:search/search.dart';

import '../provider/tvshow_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTvShow])
void main() {
  late SearchTvshowBloc searchTvshowBloc;
  late MockSearchTvShow mockSearchTvShow;

  setUp(() {
    mockSearchTvShow = MockSearchTvShow();
    searchTvshowBloc = SearchTvshowBloc(mockSearchTvShow);
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
  final tQuery = "game";

  blocTest<SearchTvshowBloc, SearchTvshowState>(
      "Should emit [Loading, HasData] when data is gotten successfully",
      build: () {
        when(mockSearchTvShow.execute(tQuery))
            .thenAnswer((_) async => Right(tTvShowList));
        return searchTvshowBloc;
      },
      act: (bloc) => bloc.add(OnTvShowQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 100),
      expect: () => [SearchTvShowLoading(), SearchTvShowHasData(tTvShowList)],
      verify: (bloc) => verify(mockSearchTvShow.execute(tQuery)));

  // blocTest<SearchTvshowBloc, SearchTvshowState>(
  //     "Should emit [Loading, Error] when get search is unsuccessfull",
  //     build: () {});
}
