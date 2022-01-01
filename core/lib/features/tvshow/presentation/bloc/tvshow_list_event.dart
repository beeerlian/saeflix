part of 'tvshow_list_bloc.dart';

abstract class TvShowListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNowPlayingTvShows extends TvShowListEvent {}

class FetchPopularTvShows extends TvShowListEvent {}

class FetchTopRatedTvShows extends TvShowListEvent {}
