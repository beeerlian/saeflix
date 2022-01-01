part of 'watchlist_tvshow_bloc.dart';

abstract class WatchlistTvShowsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WatchlistTvShowsLoading extends WatchlistTvShowsState {}

class WatchlistTvShowsFailed extends WatchlistTvShowsState {
  String message;

  WatchlistTvShowsFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class WatchlistTvShowsLoaded extends WatchlistTvShowsState {
  List<TvShow> tvShow;

  WatchlistTvShowsLoaded(this.tvShow);
  @override
  List<Object?> get props => [tvShow];
}
