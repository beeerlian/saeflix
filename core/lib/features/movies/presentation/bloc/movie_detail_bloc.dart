import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:core/features/movies/domain/usecases/get_movie_recommendations.dart';
import 'package:core/features/movies/domain/usecases/get_watchlist_status.dart';
import 'package:core/features/movies/domain/usecases/remove_watchlist.dart';
import 'package:core/features/movies/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;

  MovieDetailBloc(this.getMovieDetail) : super(MovieDetailLoading());

  @override
  Stream<MovieDetailState> mapEventToState(MovieDetailEvent event) async* {
    if (event is FetchMovieDetail) {
      yield MovieDetailLoading();

      final result = await getMovieDetail.execute(event.id);

      yield* result.fold((failure) async* {
        yield MovieDetailFailure(failure.message);
      }, (movie) async* {
        yield MovieDetailLoaded(movie);
      });
    }
  }
}

class MovieRecommendationBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieRecommendations getMovieRecommendations;

  MovieRecommendationBloc(
    this.getMovieRecommendations,
  ) : super(MovieDetailLoading());

  @override
  Stream<MovieDetailState> mapEventToState(MovieDetailEvent event) async* {
    if (event is FetchMovieRecommendation) {
      yield MovieDetailLoading();

      final result = await getMovieRecommendations.execute(event.id);

      yield* result.fold((failure) async* {
        print("RECOMMENDATION ERROR");
        yield MovieRecommendationsFailure(failure.message);
      }, (movies) async* {
        print("RECOMMENDATION LOADED");
        yield MovieRecommendationsLoaded(movies);
      });
    }
  }
}

class MovieWatchlistBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieWatchlistBloc(
    this.getWatchListStatus,
    this.saveWatchlist,
    this.removeWatchlist,
  ) : super(MovieDetailLoading());

  @override
  Stream<MovieDetailState> mapEventToState(MovieDetailEvent event) async* {
    if (event is LoadMovieWatchlistStatus) {
      final result = await getWatchListStatus.execute(event.id);
      yield IsAddedToWatchListStatus(result);
    } else if (event is AddMovieWatchlist) {
      final result = await saveWatchlist.execute(event.movie);

      yield* result.fold((failure) async* {
        yield AddedToWatchlistFailure(failure.message);
      }, (successMessage) async* {
        yield AddedToWatchlistSuccess(successMessage);
      });

      final loadResult = await getWatchListStatus.execute(event.movie.id);
      yield IsAddedToWatchListStatus(loadResult);
    } else if (event is RemoveMovieWatchlist) {
      final result = await removeWatchlist.execute(event.movie);

      yield* result.fold((failure) async* {
        yield RemoveWatchlistFailure(failure.message);
      }, (successMessage) async* {
        yield RemoveWatchlistSuccess(successMessage);
      });

      final loadResult = await getWatchListStatus.execute(event.movie.id);
      yield IsAddedToWatchListStatus(loadResult);
    }
  }
}
