import 'package:core/core.dart';
import 'package:core/features/movies/domain/repositories/movie_repository.dart';
import 'package:core/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:core/features/movies/domain/usecases/get_movie_recommendations.dart';
import 'package:core/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:core/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:core/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:core/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:core/features/movies/domain/usecases/get_watchlist_status.dart';
import 'package:core/features/movies/domain/usecases/remove_watchlist.dart';
import 'package:core/features/movies/domain/usecases/save_watchlist.dart';
import 'package:core/features/movies/presentation/bloc/movie_detail_bloc.dart';
import 'package:core/features/movies/presentation/bloc/movie_list_bloc.dart';
import 'package:core/features/tvshow/domain/repositories/tvshow_repository.dart';
import 'package:core/features/tvshow/domain/usecases/get_now_playing_tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_popular_tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_top_rated_tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/get_tvshow_detail.dart';
import 'package:core/features/tvshow/domain/usecases/get_tvshow_recommendation.dart';
import 'package:core/features/tvshow/domain/usecases/get_tvshow_watchlist_status.dart';
import 'package:core/features/tvshow/domain/usecases/get_watchlist_tvshow.dart';
import 'package:core/features/tvshow/domain/usecases/remove_tvshow_watchlist.dart';
import 'package:core/features/tvshow/domain/usecases/save_tvshow_watchlist.dart';
import 'package:core/features/tvshow/presentation/bloc/popular_tvshow_bloc.dart';
import 'package:core/features/tvshow/presentation/bloc/top_rated_tvshow_bloc.dart';
import 'package:core/features/tvshow/presentation/bloc/tvshow_detail_bloc.dart';
import 'package:core/features/tvshow/presentation/bloc/tvshow_list_bloc.dart';
import 'package:core/features/tvshow/presentation/bloc/watchlist_tvshow_bloc.dart';
import 'package:core/utils/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:search/search.dart';

final locator = GetIt.instance;
void init() {
  //movies bloc
  locator.registerFactory(() => SearchMovieBloc(locator()));
  locator.registerFactory(() => NowPlayingMoviesBloc(locator()));
  locator.registerFactory(() => PopularMoviesBloc(locator()));
  locator.registerFactory(() => MovieRecommendationBloc(locator()));
  locator.registerFactory(() => TopRatedMoviesBloc(locator()));
  locator.registerFactory(() => MovieDetailBloc(locator()));
  locator.registerFactory(
      () => MovieWatchlistBloc(locator(), locator(), locator()));
  locator.registerFactory(() => AllPopularMoviesBloc(locator()));
  locator.registerFactory(() => AllTopRatedMoviesBloc(locator()));
  locator.registerFactory(() => AllWatchlistMoviesBloc(locator()));
  //tvshow bloc
  locator.registerFactory(() => SearchTvshowBloc(locator()));
  locator.registerFactory(() => NowPlayingTvShowBloc(locator()));
  locator.registerFactory(() => PopularTvShowBloc(locator()));
  locator.registerFactory(() => TvShowRecommendationBloc(locator()));
  locator.registerFactory(() => TopRatedTvShowBloc(locator()));
  locator.registerFactory(() => TvShowDetailBloc(locator()));
  locator.registerFactory(
      () => TvShowWatchlistBloc(locator(), locator(), locator()));
  locator.registerFactory(() => AllPopularTvShowsBloc(locator()));
  locator.registerFactory(() => AllTopRatedTvShowsBloc(locator()));
  locator.registerFactory(() => AllWatchlistTvShowsBloc(locator()));

  //movies provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );

  //tvshow provider
  locator.registerFactory(
    () => TvShowListNotifier(
        getNowPlayingTvShows: locator(),
        getPopularTvShows: locator(),
        getTopRatedTvShows: locator()),
  );
  locator.registerFactory(
    () => TvShowDetailNotifier(
        getTvShowDetail: locator(),
        getTvShowRecommendation: locator(),
        getTvShowWatchListStatus: locator(),
        saveTvShowWatchList: locator(),
        removeTvShowWatchList: locator()),
  );
  locator.registerFactory(() => TvShowSearchNotifier(
        searchTvShows: locator(),
      ));
  locator.registerFactory(() => PopularTvShowsNotifier(
        getPopularTvShows: locator(),
      ));
  locator.registerFactory(() => TopRatedTvShowsNotifier(
        getTopRatedTvShows: locator(),
      ));
  locator.registerFactory(
    () => WatchlistTvShowNotifier(getWatchlistTvShows: locator()),
  );

  // movies use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // tvshow use case
  locator.registerLazySingleton(() => GetNowPlayingTvShow(locator()));
  locator.registerLazySingleton(() => GetPopularTvShow(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvShow(locator()));
  locator.registerLazySingleton(() => GetTvShowDetail(locator()));
  locator.registerLazySingleton(() => GetTvShowRecommendation(locator()));
  locator.registerLazySingleton(() => SearchTvShow(locator()));
  locator.registerLazySingleton(() => GetTvShowWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveTvShowWatchList(locator()));
  locator.registerLazySingleton(() => RemoveTvShowWatchList(locator()));
  locator.registerLazySingleton(() => GetWatchListTvShow(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
        remoteDataSource: locator(),
        localDataSource: locator(),
        networkInfo: locator()),
  );
  locator.registerLazySingleton<TvShowRepository>(
    () => TvShowRepositoryImpl(
        remoteDatasource: locator(),
        localDataSource: locator(),
        networkInfo: locator()),
  );

  //movies data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  //tvshow data sources
  locator.registerLazySingleton<TvShowRemoteDataSource>(
      () => TvShowRemoteDataSourceImpl(locator()));
  locator.registerLazySingleton<TvShowLocalDataSource>(
      () => TvShowLocalDataSourceImpl(locator()));

  // tvshow & movies db helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => DataConnectionChecker());

  //network info
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));
}
