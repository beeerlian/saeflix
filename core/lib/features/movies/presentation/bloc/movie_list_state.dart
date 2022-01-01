part of 'movie_list_bloc.dart';

@immutable
abstract class MovieListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieListInitial extends MovieListState {}

class NowPlayingMovieListLoading extends MovieListState {}

class PopularMovieListLoading extends MovieListState {}

class TopRatedMovieListLoading extends MovieListState {}

class NowPlayingMovieListLoaded extends MovieListState {
  List<Movie> movies;
  NowPlayingMovieListLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class NowPlayingMovieListHasError extends MovieListState {
  String message;

  NowPlayingMovieListHasError(this.message);
  @override
  List<Object?> get props => [message];
}

class PopularMovieListLoaded extends MovieListState {
  List<Movie> movies;
  PopularMovieListLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class PopularMovieListHasError extends MovieListState {
  String message;

  PopularMovieListHasError(this.message);
  @override
  List<Object?> get props => [message];
}

class TopRatedMovieListLoaded extends MovieListState {
  List<Movie> movies;
  TopRatedMovieListLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class TopRatedMovieListHasError extends MovieListState {
  String message;

  TopRatedMovieListHasError(this.message);
  @override
  List<Object?> get props => [message];
}
