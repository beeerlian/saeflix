import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class AllWatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies _getWatchlistMovies;

  AllWatchlistMoviesBloc(this._getWatchlistMovies)
      : super(WatchlistMoviesLoading());

  @override
  Stream<WatchlistMoviesState> mapEventToState(
      WatchlistMoviesEvent event) async* {
    if (event is FetchAllWatchlistMovies) {
      yield WatchlistMoviesLoading();

      final result = await _getWatchlistMovies.execute();

      yield* result.fold((failure) async* {
        yield WatchlistMoviesFailed(failure.message);
      }, (moviesData) async* {
        yield WatchlistMoviesLoaded(moviesData);
      });
    }
  }
}
