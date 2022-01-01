part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMoviesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WatchlistMoviesLoading extends WatchlistMoviesState {}

class WatchlistMoviesFailed extends WatchlistMoviesState {
  String message;

  WatchlistMoviesFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class WatchlistMoviesLoaded extends WatchlistMoviesState {
  List<Movie> movies;

  WatchlistMoviesLoaded(this.movies);
  @override
  List<Object?> get props => [movies];
}
