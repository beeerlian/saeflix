import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/entities/tvshow_detail.dart';
import 'package:core/features/tvshow/domain/usecases/get_tvshow_detail.dart';
import 'package:core/features/tvshow/domain/usecases/get_tvshow_recommendation.dart';
import 'package:core/features/tvshow/domain/usecases/get_tvshow_watchlist_status.dart';
import 'package:core/features/tvshow/domain/usecases/remove_tvshow_watchlist.dart';
import 'package:core/features/tvshow/domain/usecases/save_tvshow_watchlist.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/widgets.dart';

class TvShowDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvShowDetail getTvShowDetail;
  final GetTvShowRecommendation getTvShowRecommendation;
  final GetTvShowWatchListStatus getTvShowWatchListStatus;
  final SaveTvShowWatchList saveTvShowWatchList;
  final RemoveTvShowWatchList removeTvShowWatchList;

  TvShowDetailNotifier({
    required this.getTvShowDetail,
    required this.getTvShowRecommendation,
    required this.getTvShowWatchListStatus,
    required this.saveTvShowWatchList,
    required this.removeTvShowWatchList,
  });

  late TvShowDetail _tvshow;
  TvShowDetail get tvshow => _tvshow;

  RequestState _tvshowState = RequestState.Empty;
  RequestState get tvshowState => _tvshowState;

  List<TvShow> _tvshowRecommendations = [];
  List<TvShow> get tvshowRecommendations => _tvshowRecommendations;

  RequestState _tvshowRecommendationsState = RequestState.Empty;
  RequestState get tvshowRecommendationsState => _tvshowRecommendationsState;

  String _message = '';
  String get message => _message;

  bool _addToWatchlistStatus = false;
  bool get addToWatchlistStatus => _addToWatchlistStatus;

  String _watchListmessage = '';
  String get watchListmessage => _watchListmessage;

  Future<void> fetchTvShowDetail(int id) async {
    _tvshowState = RequestState.Loading;
    notifyListeners();
    final detailTvShowresult = await getTvShowDetail.execute(id);
    final tvShowRecommendationsResult =
        await getTvShowRecommendation.execute(id);

    detailTvShowresult.fold((failure) {
      _tvshowState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvShowDetail) {
      _tvshowRecommendationsState = RequestState.Loading;
      _tvshow = tvShowDetail;
      notifyListeners();
      tvShowRecommendationsResult.fold((failure) {
        _tvshowRecommendationsState = RequestState.Error;
        _message = failure.message;
      }, (tvShowRecomendations) {
        _tvshowRecommendationsState = RequestState.Loaded;
        _tvshowRecommendations = tvShowRecomendations;
      });
      _tvshowState = RequestState.Loaded;
      notifyListeners();
    });
  }

  Future<void> addWatchlist(TvShowDetail tvshow) async {
    final result = await saveTvShowWatchList.execute(tvshow);

    await result.fold(
      (failure) async {
        _watchListmessage = failure.message;
      },
      (success) async {
        _watchListmessage = success;
      },
    );

    await loadWatchlistStatus(tvshow.id);
  }

  Future<void> removeFromWatchlist(TvShowDetail tvshow) async {
    final result = await removeTvShowWatchList.execute(tvshow);

    await result.fold(
      (failure) async {
        _watchListmessage = failure.message;
      },
      (successMessage) async {
        _watchListmessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvshow.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getTvShowWatchListStatus.execute(id);
    _addToWatchlistStatus = result;
    notifyListeners();
  }
}
