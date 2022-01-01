import 'package:bloc/bloc.dart';
import 'package:core/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';

import '../../../../core.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class AllPopularMoviesBloc
    extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies _getPopularMovies;

  AllPopularMoviesBloc(this._getPopularMovies) : super(PopularMoviesLoading());

  @override
  Stream<PopularMoviesState> mapEventToState(PopularMoviesEvent event) async* {
    if (event is FetchAllPopularMovies) {
      yield PopularMoviesLoading();

      final result = await _getPopularMovies.execute();

      yield* result.fold((failure) async* {
        yield PopularMoviesFailed(failure.message);
      }, (moviesData) async* {
        yield PopularMoviesLoaded(moviesData);
      });
    }
  }
}
