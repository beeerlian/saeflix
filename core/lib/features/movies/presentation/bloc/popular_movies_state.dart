part of 'popular_movies_bloc.dart';

abstract class PopularMoviesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PopularMoviesLoading extends PopularMoviesState {}

class PopularMoviesFailed extends PopularMoviesState {
  String message;

  PopularMoviesFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class PopularMoviesLoaded extends PopularMoviesState {
  List<Movie> movies;

  PopularMoviesLoaded(this.movies);
  @override
  List<Object?> get props => [movies];
}
