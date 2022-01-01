import 'dart:developer';

import 'package:about/about.dart';
import 'package:core/features/movies/presentation/bloc/movie_list_bloc.dart';
import 'package:core/features/movies/presentation/pages/home_movie_page.dart';
import 'package:core/features/tvshow/presentation/bloc/tvshow_list_bloc.dart';
import 'package:core/features/tvshow/presentation/pages/home_tvshow_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search/search.dart';

import 'all_watchlist_page.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  int _currentIndex = 0;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  late TabController controller;
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<NowPlayingMoviesBloc>().add(FetchNowPlayingMovies()));
    Future.microtask(
        () => context.read<PopularMoviesBloc>().add(FetchPopularMovies()));
    Future.microtask(
        () => context.read<TopRatedMoviesBloc>().add(FetchTopRatedMovies()));

    Future.microtask(() =>
        context.read<NowPlayingTvShowBloc>().add(FetchNowPlayingTvShows()));
    Future.microtask(
        () => context.read<PopularTvShowBloc>().add(FetchPopularTvShows()));
    Future.microtask(
        () => context.read<TopRatedTvShowBloc>().add(FetchTopRatedTvShows()));

    controller = new TabController(vsync: this, length: pages.length);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  final pages = [HomeMoviePage(), HomeTvShowPage()];

  final tabs = [
    Tab(
      // icon: Icon(Icons.movie_creation_outlined),
      text: 'Movies',
    ),
    Tab(
      // icon: Icon(Icons.tv),
      text: "Tv Show",
    ),
  ];

  final _bottomNavigationItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Movie"),
    BottomNavigationBarItem(
      icon: Icon(Icons.tv),
      label: "Tv Show",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      drawer: _buildMyDrawer(),
      appBar: _buildMyAppBar(),
      body: TabBarView(controller: controller, children: pages),
    );
  }

  AppBar _buildMyAppBar() {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            _scaffoldkey.currentState!.openDrawer();
          },
          icon: const Icon(Icons.menu)),
      title: const Text('Saeflix'),
      bottom: TabBar(controller: controller, tabs: tabs),
      actions: [
        IconButton(
          onPressed: () {
            // FirebaseCrashlytics.instance.crash();
            widget._currentIndex = controller.index;
            var route = widget._currentIndex == 0
                ? MovieSearchPage.ROUTE_NAME
                : TvShowSearchPage.ROUTE_NAME;
            log(route);
            Navigator.pushNamed(context, route);
          },
          icon: Icon(Icons.search),
        )
      ],
    );
  }

  Drawer _buildMyDrawer() {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/circle-g.png'),
            ),
            accountName: Text('Saeflix'),
            accountEmail: Text('naufal.berlian.99@gmail.com'),
          ),
          ListTile(
            leading: const Icon(Icons.movie),
            title: const Text('Movies'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: const Text('Watchlist'),
            onTap: () {
              Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
            },
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
            },
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
          ),
        ],
      ),
    );
  }

  void _changeSelectedNavBar(int index) {
    setState(() {
      widget._currentIndex = index;
    });
  }
}
