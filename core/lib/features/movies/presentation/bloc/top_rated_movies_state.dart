part of 'top_rated_movies_bloc.dart';

abstract class TopRatedMoviesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TopRatedMoviesLoading extends TopRatedMoviesState {}

class TopRatedMoviesFailed extends TopRatedMoviesState {
  String message;

  TopRatedMoviesFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class TopRatedMoviesLoaded extends TopRatedMoviesState {
  List<Movie> movies;

  TopRatedMoviesLoaded(this.movies);
  @override
  List<Object?> get props => [movies];
}
