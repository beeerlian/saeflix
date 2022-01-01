part of 'tvshow_list_bloc.dart';

@immutable
abstract class TvShowListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvShowListInitial extends TvShowListState {}

class NowPlayingTvShowListLoading extends TvShowListState {}

class PopularTvShowListLoading extends TvShowListState {}

class TopRatedTvShowListLoading extends TvShowListState {}

class NowPlayingTvShowListLoaded extends TvShowListState {
  List<TvShow> tvShows;
  NowPlayingTvShowListLoaded(this.tvShows);

  @override
  List<Object?> get props => [tvShows];
}

class NowPlayingTvShowListHasError extends TvShowListState {
  String message;

  NowPlayingTvShowListHasError(this.message);
  @override
  List<Object?> get props => [message];
}

class PopularTvShowListLoaded extends TvShowListState {
  List<TvShow> tvShows;
  PopularTvShowListLoaded(this.tvShows);

  @override
  List<Object?> get props => [tvShows];
}

class PopularTvShowListHasError extends TvShowListState {
  String message;

  PopularTvShowListHasError(this.message);
  @override
  List<Object?> get props => [message];
}

class TopRatedTvShowListLoaded extends TvShowListState {
  List<TvShow> tvShows;
  TopRatedTvShowListLoaded(this.tvShows);

  @override
  List<Object?> get props => [tvShows];
}

class TopRatedTvShowListHasError extends TvShowListState {
  String message;

  TopRatedTvShowListHasError(this.message);
  @override
  List<Object?> get props => [message];
}
