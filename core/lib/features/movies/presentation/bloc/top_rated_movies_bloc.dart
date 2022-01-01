import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class AllTopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies _getTopRatedMovies;

  AllTopRatedMoviesBloc(this._getTopRatedMovies)
      : super(TopRatedMoviesLoading());

  @override
  Stream<TopRatedMoviesState> mapEventToState(
      TopRatedMoviesEvent event) async* {
    if (event is FetchAllTopRatedMovies) {
      yield TopRatedMoviesLoading();

      final result = await _getTopRatedMovies.execute();

      yield* result.fold((failure) async* {
        yield TopRatedMoviesFailed(failure.message);
      }, (moviesData) async* {
        yield TopRatedMoviesLoaded(moviesData);
      });
    }
  }
}
