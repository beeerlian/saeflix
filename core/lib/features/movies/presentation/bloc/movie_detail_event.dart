part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {}

class FetchMovieDetail extends MovieDetailEvent {
  int id;
  FetchMovieDetail(this.id);
  @override
  List<Object?> get props => [id];
}

class FetchMovieRecommendation extends MovieDetailEvent {
  int id;
  FetchMovieRecommendation(this.id);
  @override
  List<Object?> get props => [id];
}

class AddMovieWatchlist extends MovieDetailEvent {
  MovieDetail movie;
  AddMovieWatchlist(this.movie);
  @override
  List<Object?> get props => [movie];
}

class RemoveMovieWatchlist extends MovieDetailEvent {
  MovieDetail movie;
  RemoveMovieWatchlist(this.movie);
  @override
  List<Object?> get props => [movie];
}

class LoadMovieWatchlistStatus extends MovieDetailEvent {
  int id;
  LoadMovieWatchlistStatus(this.id);
  @override
  List<Object?> get props => [id];
}
