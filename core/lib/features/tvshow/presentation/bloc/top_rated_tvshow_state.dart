part of 'top_rated_tvshow_bloc.dart';

abstract class TopRatedTvShowsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TopRatedTvShowsLoading extends TopRatedTvShowsState {}

class TopRatedTvShowsFailed extends TopRatedTvShowsState {
  String message;

  TopRatedTvShowsFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class TopRatedTvShowsLoaded extends TopRatedTvShowsState {
  List<TvShow> tvShows;

  TopRatedTvShowsLoaded(this.tvShows);
  @override
  List<Object?> get props => [tvShows];
}
