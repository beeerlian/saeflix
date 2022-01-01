part of 'popular_tvshow_bloc.dart';

abstract class PopularTvShowsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PopularTvShowsLoading extends PopularTvShowsState {}

class PopularTvShowsFailed extends PopularTvShowsState {
  String message;

  PopularTvShowsFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class PopularTvShowsLoaded extends PopularTvShowsState {
  List<TvShow> movies;

  PopularTvShowsLoaded(this.movies);
  @override
  List<Object?> get props => [movies];
}
