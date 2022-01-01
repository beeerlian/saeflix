import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_top_rated_tvshow.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';

class TopRatedTvShowsNotifier extends ChangeNotifier {
  final GetTopRatedTvShow getTopRatedTvShows;

  TopRatedTvShowsNotifier({required this.getTopRatedTvShows});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TvShow> _tvShows = [];
  List<TvShow> get tvShows => _tvShows;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedTvShows() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvShows.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvShowsData) {
        _tvShows = tvShowsData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
