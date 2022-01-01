part of 'top_rated_movies_bloc.dart';

abstract class TopRatedMoviesEvent extends Equatable {}

class FetchAllTopRatedMovies extends TopRatedMoviesEvent {
  @override
  List<Object?> get props => [];
}
