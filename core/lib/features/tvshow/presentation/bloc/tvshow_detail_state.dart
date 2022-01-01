part of 'tvshow_detail_bloc.dart';

abstract class TvShowDetailState extends Equatable {}

class TvShowDetailEmpty extends TvShowDetailState {
  @override
  List<Object?> get props => [];
}

class TvShowDetailLoading extends TvShowDetailState {
  @override
  List<Object?> get props => [];
}

class TvShowDetailLoaded extends TvShowDetailState {
  TvShowDetail tvShow;

  TvShowDetailLoaded(this.tvShow);
  @override
  List<Object?> get props => [tvShow];
}

class TvShowDetailFailure extends TvShowDetailState {
  String message;
  TvShowDetailFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class TvShowRecommendationsEmpty extends TvShowDetailState {
  @override
  List<Object?> get props => [];
}

class TvShowRecommendationsLoading extends TvShowDetailState {
  @override
  List<Object?> get props => [];
}

class TvShowRecommendationsFailure extends TvShowDetailState {
  String message;
  TvShowRecommendationsFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class TvShowRecommendationsLoaded extends TvShowDetailState {
  List<TvShow> tvShowRecommendation;

  TvShowRecommendationsLoaded(this.tvShowRecommendation);

  @override
  List<Object?> get props => [tvShowRecommendation];
}

class IsAddedTvShowToWatchListStatus extends TvShowDetailState {
  bool status;

  IsAddedTvShowToWatchListStatus(this.status);
  @override
  List<Object?> get props => [status];
}

class AddTvShowToWatchlistSuccess extends TvShowDetailState {
  String message;

  AddTvShowToWatchlistSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class AddTvShowToWatchlistFailure extends TvShowDetailState {
  String message;

  AddTvShowToWatchlistFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class RemoveTvShowWatchlistSuccess extends TvShowDetailState {
  String message;

  RemoveTvShowWatchlistSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class RemoveTvShowWatchlistFailure extends TvShowDetailState {
  String message;

  RemoveTvShowWatchlistFailure(this.message);
  @override
  List<Object?> get props => [message];
}
