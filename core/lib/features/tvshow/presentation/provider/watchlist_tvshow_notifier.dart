import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_watchlist_tvshow.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';

class WatchlistTvShowNotifier extends ChangeNotifier {
  var _watchlistTvShows = <TvShow>[];
  List<TvShow> get watchlistTvShows => _watchlistTvShows;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistTvShowNotifier({required this.getWatchlistTvShows});

  final GetWatchListTvShow getWatchlistTvShows;

  Future<void> fetchWatchlistTvShows() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTvShows.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _watchlistState = RequestState.Loaded;
        _watchlistTvShows = tvShowsData;
        notifyListeners();
      },
    );
  }
}
