import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_now_playing_tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_popular_tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_top_rated_tvshow.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';

class TvShowListNotifier extends ChangeNotifier {
  var _nowPlayingTvShow = <TvShow>[];
  List<TvShow> get nowPlayingTvShows => _nowPlayingTvShow;

  RequestState _nowPlayingState = RequestState.Empty;
  RequestState get nowPlayingState => _nowPlayingState;

  var _popularTvShows = <TvShow>[];
  List<TvShow> get popularTvShows => _popularTvShows;

  RequestState _popularTvShowsState = RequestState.Empty;
  RequestState get popularTvShowsState => _popularTvShowsState;

  var _topRatedTvShows = <TvShow>[];
  List<TvShow> get topRatedTvShows => _topRatedTvShows;

  RequestState _topRatedTvShowsState = RequestState.Empty;
  RequestState get topRatedTvShowsState => _topRatedTvShowsState;

  String _message = '';
  String get message => _message;

  TvShowListNotifier({
    required this.getNowPlayingTvShows,
    required this.getPopularTvShows,
    required this.getTopRatedTvShows,
  });

  final GetNowPlayingTvShow getNowPlayingTvShows;
  final GetPopularTvShow getPopularTvShows;
  final GetTopRatedTvShow getTopRatedTvShows;

  Future<void> fetchNowPlayingTvShows() async {
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTvShows.execute();
    result.fold(
      (failure) {
        _nowPlayingState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _nowPlayingState = RequestState.Loaded;
        _nowPlayingTvShow = tvShowsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvShows() async {
    _popularTvShowsState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvShows.execute();
    result.fold(
      (failure) {
        _popularTvShowsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _popularTvShowsState = RequestState.Loaded;
        _popularTvShows = tvShowsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvShows() async {
    _topRatedTvShowsState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvShows.execute();
    result.fold(
      (failure) {
        _topRatedTvShowsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowData) {
        _topRatedTvShowsState = RequestState.Loaded;
        _topRatedTvShows = tvShowData;
        notifyListeners();
      },
    );
  }
}
