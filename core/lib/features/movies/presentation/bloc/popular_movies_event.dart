part of 'popular_movies_bloc.dart';

abstract class PopularMoviesEvent extends Equatable {}

class FetchAllPopularMovies extends PopularMoviesEvent {
  @override
  List<Object?> get props => [];
}
