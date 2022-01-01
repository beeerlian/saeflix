import 'package:bloc/bloc.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/features/tvshow/domain/usecases/search_tvshow.dart';

part 'search_tvshow_event.dart';
part 'search_tvshow_state.dart';

class SearchTvshowBloc extends Bloc<SearchTvshowEvent, SearchTvshowState> {
  final SearchTvShow _searchTvShow;

  SearchTvshowBloc(this._searchTvShow) : super(SearchTvShowEmpty());

  @override
  Stream<SearchTvshowState> mapEventToState(SearchTvshowEvent event) async* {
    if (event is OnTvShowQueryChanged) {
      yield SearchTvShowLoading();
      String query = event.query;

      final results = await _searchTvShow.execute(query);
      yield* results.fold((failure) async* {
        yield SearchTvShowError(failure.message);
      }, (results) async* {
        yield SearchTvShowHasData(results);
      });
    }
  }

  @override
  Stream<Transition<SearchTvshowEvent, SearchTvshowState>> transformEvents(
      Stream<SearchTvshowEvent> events,
      TransitionFunction<SearchTvshowEvent, SearchTvshowState>
          transitionFunction) {
    return super.transformEvents(
        events.debounceTime(const Duration(milliseconds: 100)),
        transitionFunction);
  }
}
