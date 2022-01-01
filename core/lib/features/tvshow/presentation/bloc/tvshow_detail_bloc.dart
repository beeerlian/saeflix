import 'package:bloc/bloc.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/entities/tvshow_detail.dart';
import 'package:core/features/tvshow/domain/usecases/get_tvshow_detail.dart';
import 'package:core/features/tvshow/domain/usecases/get_tvshow_recommendation.dart';
import 'package:core/features/tvshow/domain/usecases/get_tvshow_watchlist_status.dart';
import 'package:core/features/tvshow/domain/usecases/remove_tvshow_watchlist.dart';
import 'package:core/features/tvshow/domain/usecases/save_tvshow_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'tvshow_detail_event.dart';
part 'tvshow_detail_state.dart';

class TvShowDetailBloc extends Bloc<TvShowDetailEvent, TvShowDetailState> {
  final GetTvShowDetail getTvShowDetail;

  TvShowDetailBloc(this.getTvShowDetail) : super(TvShowDetailLoading());

  @override
  Stream<TvShowDetailState> mapEventToState(TvShowDetailEvent event) async* {
    if (event is FetchTvShowDetail) {
      yield TvShowDetailLoading();

      final result = await getTvShowDetail.execute(event.id);

      yield* result.fold((failure) async* {
        yield TvShowDetailFailure(failure.message);
      }, (tvShow) async* {
        yield TvShowDetailLoaded(tvShow);
      });
    }
  }
}

class TvShowRecommendationBloc
    extends Bloc<TvShowDetailEvent, TvShowDetailState> {
  final GetTvShowRecommendation getTvShowRecommendations;

  TvShowRecommendationBloc(
    this.getTvShowRecommendations,
  ) : super(TvShowDetailLoading());

  @override
  Stream<TvShowDetailState> mapEventToState(TvShowDetailEvent event) async* {
    if (event is FetchTvShowRecommendation) {
      yield TvShowDetailLoading();

      final result = await getTvShowRecommendations.execute(event.id);

      yield* result.fold((failure) async* {
        print("RECOMMENDATION ERROR");
        yield TvShowRecommendationsFailure(failure.message);
      }, (tvShows) async* {
        print("RECOMMENDATION LOADED");
        yield TvShowRecommendationsLoaded(tvShows);
      });
    }
  }
}

class TvShowWatchlistBloc extends Bloc<TvShowDetailEvent, TvShowDetailState> {
  final GetTvShowWatchListStatus getWatchListStatus;
  final SaveTvShowWatchList saveWatchlist;
  final RemoveTvShowWatchList removeWatchlist;

  TvShowWatchlistBloc(
    this.getWatchListStatus,
    this.saveWatchlist,
    this.removeWatchlist,
  ) : super(TvShowDetailLoading());

  @override
  Stream<TvShowDetailState> mapEventToState(TvShowDetailEvent event) async* {
    if (event is LoadTvShowWatchlistStatus) {
      final result = await getWatchListStatus.execute(event.id);
      yield IsAddedTvShowToWatchListStatus(result);
    } else if (event is AddTvShowWatchlist) {
      final result = await saveWatchlist.execute(event.tvShow);

      yield* result.fold((failure) async* {
        yield AddTvShowToWatchlistFailure(failure.message);
      }, (successMessage) async* {
        yield AddTvShowToWatchlistSuccess(successMessage);
      });

      final loadResult = await getWatchListStatus.execute(event.tvShow.id);
      yield IsAddedTvShowToWatchListStatus(loadResult);
    } else if (event is RemoveTvShowWatchlistEvent) {
      final result = await removeWatchlist.execute(event.tvShow);

      yield* result.fold((failure) async* {
        yield RemoveTvShowWatchlistFailure(failure.message);
      }, (successMessage) async* {
        yield RemoveTvShowWatchlistSuccess(successMessage);
      });

      final loadResult = await getWatchListStatus.execute(event.tvShow.id);
      yield IsAddedTvShowToWatchListStatus(loadResult);
    }
  }
}
