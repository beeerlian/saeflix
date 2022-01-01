part of 'tvshow_detail_bloc.dart';

abstract class TvShowDetailEvent extends Equatable {}

class FetchTvShowDetail extends TvShowDetailEvent {
  int id;
  FetchTvShowDetail(this.id);
  @override
  List<Object?> get props => [id];
}

class FetchTvShowRecommendation extends TvShowDetailEvent {
  int id;
  FetchTvShowRecommendation(this.id);
  @override
  List<Object?> get props => [id];
}

class AddTvShowWatchlist extends TvShowDetailEvent {
  TvShowDetail tvShow;
  AddTvShowWatchlist(this.tvShow);
  @override
  List<Object?> get props => [tvShow];
}

class RemoveTvShowWatchlistEvent extends TvShowDetailEvent {
  TvShowDetail tvShow;
  RemoveTvShowWatchlistEvent(this.tvShow);
  @override
  List<Object?> get props => [tvShow];
}

class LoadTvShowWatchlistStatus extends TvShowDetailEvent {
  int id;
  LoadTvShowWatchlistStatus(this.id);
  @override
  List<Object?> get props => [id];
}
