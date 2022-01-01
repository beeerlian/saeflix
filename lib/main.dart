import 'package:about/about.dart';
import 'package:core/core.dart';
import 'package:core/features/movies/presentation/bloc/movie_detail_bloc.dart';
import 'package:core/features/movies/presentation/bloc/movie_list_bloc.dart';
import 'package:core/features/tvshow/presentation/bloc/popular_tvshow_bloc.dart';
import 'package:core/features/tvshow/presentation/bloc/top_rated_tvshow_bloc.dart';
import 'package:core/features/tvshow/presentation/bloc/tvshow_detail_bloc.dart';
import 'package:core/features/tvshow/presentation/bloc/tvshow_list_bloc.dart';
import 'package:core/features/tvshow/presentation/bloc/watchlist_tvshow_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:saeflix/injection.dart' as di;
import 'package:search/search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvShowListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvShowDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvShowSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedTvShowsNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularTvShowsNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistTvShowNotifier>(),
        ),
        // ---------------movies bloc provider-------------------
        BlocProvider(create: (_) => di.locator<SearchMovieBloc>()),
        BlocProvider(create: (_) => di.locator<NowPlayingMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<MovieRecommendationBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieWatchlistBloc>()),
        BlocProvider(create: (_) => di.locator<AllPopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<AllTopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<AllWatchlistMoviesBloc>()),
        //-----------tvshow bloc provider------------------------
        BlocProvider(create: (_) => di.locator<SearchTvshowBloc>()),
        BlocProvider(create: (_) => di.locator<NowPlayingTvShowBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTvShowBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvShowBloc>()),
        BlocProvider(create: (_) => di.locator<TvShowRecommendationBloc>()),
        BlocProvider(create: (_) => di.locator<TvShowDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TvShowWatchlistBloc>()),
        BlocProvider(create: (_) => di.locator<AllPopularTvShowsBloc>()),
        BlocProvider(create: (_) => di.locator<AllTopRatedTvShowsBloc>()),
        BlocProvider(create: (_) => di.locator<AllWatchlistTvShowsBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          accentColor: kMikadoYellow,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: Home(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => Home());
            case WatchlistPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            case HomeMoviePage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case MovieSearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => MovieSearchPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case HomeTvShowPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeTvShowPage());
            case PopularTvShowsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvShowsPage());
            case TopRatedTvShowsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvShowsPage());
            case TvShowDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvShowDetailPage(id: id),
                settings: settings,
              );
            case TvShowSearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TvShowSearchPage());
            case WatchlistTvShowsPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvShowsPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());

            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
