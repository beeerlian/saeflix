part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {}

class MovieDetailEmpty extends MovieDetailState {
  @override
  List<Object?> get props => [];
}

class MovieDetailLoading extends MovieDetailState {
  @override
  List<Object?> get props => [];
}

class MovieDetailLoaded extends MovieDetailState {
  MovieDetail movie;

  MovieDetailLoaded(this.movie);
  @override
  List<Object?> get props => [movie];
}

class MovieDetailFailure extends MovieDetailState {
  String message;
  MovieDetailFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class MovieRecommendationsEmpty extends MovieDetailState {
  @override
  List<Object?> get props => [];
}

class MovieRecommendationsLoading extends MovieDetailState {
  @override
  List<Object?> get props => [];
}

class MovieRecommendationsFailure extends MovieDetailState {
  String message;
  MovieRecommendationsFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class MovieRecommendationsLoaded extends MovieDetailState {
  List<Movie> movieRecommendation;

  MovieRecommendationsLoaded(this.movieRecommendation);

  @override
  List<Object?> get props => [movieRecommendation];
}

class IsAddedToWatchListStatus extends MovieDetailState {
  bool status;

  IsAddedToWatchListStatus(this.status);
  @override
  List<Object?> get props => [status];
}

class AddedToWatchlistSuccess extends MovieDetailState {
  String message;

  AddedToWatchlistSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class AddedToWatchlistFailure extends MovieDetailState {
  String message;

  AddedToWatchlistFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class RemoveWatchlistSuccess extends MovieDetailState {
  String message;

  RemoveWatchlistSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class RemoveWatchlistFailure extends MovieDetailState {
  String message;

  RemoveWatchlistFailure(this.message);
  @override
  List<Object?> get props => [message];
}
