part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMoviesEvent extends Equatable {}

class FetchAllWatchlistMovies extends WatchlistMoviesEvent {
  @override
  List<Object?> get props => [];
}
