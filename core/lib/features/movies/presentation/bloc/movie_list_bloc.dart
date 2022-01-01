import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:core/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:core/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class NowPlayingMoviesBloc extends Bloc<MovieListEvent, MovieListState> {
  GetNowPlayingMovies _getNowPlayingMovies;
  NowPlayingMoviesBloc(this._getNowPlayingMovies)
      : super(NowPlayingMovieListLoading());

  @override
  Stream<MovieListState> mapEventToState(MovieListEvent event) async* {
    if (event is FetchNowPlayingMovies) {
      yield NowPlayingMovieListLoading();
      final result = await _getNowPlayingMovies.execute();
      yield* result.fold((failure) async* {
        yield NowPlayingMovieListHasError(failure.message);
      }, (moviesData) async* {
        yield NowPlayingMovieListLoaded(moviesData);
      });
    }
  }
}

class PopularMoviesBloc extends Bloc<MovieListEvent, MovieListState> {
  GetPopularMovies _getPopularMovies;
  PopularMoviesBloc(this._getPopularMovies) : super(PopularMovieListLoading());

  @override
  Stream<MovieListState> mapEventToState(MovieListEvent event) async* {
    if (event is FetchPopularMovies) {
      yield PopularMovieListLoading();

      final result = await _getPopularMovies.execute();
      yield* result.fold((failure) async* {
        yield PopularMovieListHasError(failure.message);
      }, (moviesData) async* {
        yield PopularMovieListLoaded(moviesData);
      });
    }
  }
}

class TopRatedMoviesBloc extends Bloc<MovieListEvent, MovieListState> {
  GetTopRatedMovies _getTopRatedMovies;
  TopRatedMoviesBloc(this._getTopRatedMovies)
      : super(TopRatedMovieListLoading());

  @override
  Stream<MovieListState> mapEventToState(MovieListEvent event) async* {
    if (event is FetchTopRatedMovies) {
      yield TopRatedMovieListLoading();

      final result = await _getTopRatedMovies.execute();
      yield* result.fold((failure) async* {
        yield TopRatedMovieListHasError(failure.message);
      }, (moviesData) async* {
        yield TopRatedMovieListLoaded(moviesData);
      });
    }
  }
}
