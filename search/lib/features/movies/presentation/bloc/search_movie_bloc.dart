import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/features/movies/domain/usecases/search_movies.dart';

part 'search_movie_event.dart';
part 'search_movie_state.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  final SearchMovies _searchMovies;

  SearchMovieBloc(
    this._searchMovies,
  ) : super(SearchMovieEmpty());

  @override
  Stream<SearchMovieState> mapEventToState(SearchMovieEvent event) async* {
    if (event is OnMovieQueryChanged) {
      String query = event.query;
      yield SearchMovieLoading();

      final result = await _searchMovies.execute(query);

      yield* result.fold((failure) async* {
        yield SearchMovieError(failure.message);
      }, (result) async* {
        yield SearchMovieHasData(result);
      });
    }
  }

  @override
  Stream<Transition<SearchMovieEvent, SearchMovieState>> transformEvents(
      Stream<SearchMovieEvent> events,
      TransitionFunction<SearchMovieEvent, SearchMovieState> transitionFn) {
    return super.transformEvents(
        events.debounceTime(const Duration(milliseconds: 500)), transitionFn);
  }
}
