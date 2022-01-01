import 'package:bloc/bloc.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_watchlist_tvshow.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_tvshow_event.dart';
part 'watchlist_tvshow_state.dart';

class AllWatchlistTvShowsBloc
    extends Bloc<WatchlistTvShowsEvent, WatchlistTvShowsState> {
  final GetWatchListTvShow _getWatchlistTvShows;

  AllWatchlistTvShowsBloc(this._getWatchlistTvShows)
      : super(WatchlistTvShowsLoading());

  @override
  Stream<WatchlistTvShowsState> mapEventToState(
      WatchlistTvShowsEvent event) async* {
    if (event is FetchAllWatchlistTvShows) {
      yield WatchlistTvShowsLoading();

      final result = await _getWatchlistTvShows.execute();

      yield* result.fold((failure) async* {
        yield WatchlistTvShowsFailed(failure.message);
      }, (tvShowData) async* {
        yield WatchlistTvShowsLoaded(tvShowData);
      });
    }
  }
}
