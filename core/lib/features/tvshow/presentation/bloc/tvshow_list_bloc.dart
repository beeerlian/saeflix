import 'package:bloc/bloc.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_now_playing_tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_popular_tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_top_rated_tvshow.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'tvshow_list_event.dart';
part 'tvshow_list_state.dart';

class NowPlayingTvShowBloc extends Bloc<TvShowListEvent, TvShowListState> {
  GetNowPlayingTvShow _getNowPlayingTvShow;
  NowPlayingTvShowBloc(this._getNowPlayingTvShow)
      : super(NowPlayingTvShowListLoading());

  @override
  Stream<TvShowListState> mapEventToState(TvShowListEvent event) async* {
    if (event is FetchNowPlayingTvShows) {
      yield NowPlayingTvShowListLoading();
      final result = await _getNowPlayingTvShow.execute();
      yield* result.fold((failure) async* {
        yield NowPlayingTvShowListHasError(failure.message);
      }, (moviesData) async* {
        yield NowPlayingTvShowListLoaded(moviesData);
      });
    }
  }
}

class PopularTvShowBloc extends Bloc<TvShowListEvent, TvShowListState> {
  GetPopularTvShow _getPopularTvShow;
  PopularTvShowBloc(this._getPopularTvShow) : super(PopularTvShowListLoading());

  @override
  Stream<TvShowListState> mapEventToState(TvShowListEvent event) async* {
    if (event is FetchPopularTvShows) {
      yield PopularTvShowListLoading();

      final result = await _getPopularTvShow.execute();
      yield* result.fold((failure) async* {
        yield PopularTvShowListHasError(failure.message);
      }, (moviesData) async* {
        yield PopularTvShowListLoaded(moviesData);
      });
    }
  }
}

class TopRatedTvShowBloc extends Bloc<TvShowListEvent, TvShowListState> {
  GetTopRatedTvShow _getTopRatedTvShow;
  TopRatedTvShowBloc(this._getTopRatedTvShow)
      : super(TopRatedTvShowListLoading());

  @override
  Stream<TvShowListState> mapEventToState(TvShowListEvent event) async* {
    if (event is FetchTopRatedTvShows) {
      yield TopRatedTvShowListLoading();

      final result = await _getTopRatedTvShow.execute();
      yield* result.fold((failure) async* {
        yield TopRatedTvShowListHasError(failure.message);
      }, (moviesData) async* {
        yield TopRatedTvShowListLoaded(moviesData);
      });
    }
  }
}
