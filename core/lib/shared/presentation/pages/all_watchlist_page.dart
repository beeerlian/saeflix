import 'package:core/core.dart';
import 'package:core/features/movies/presentation/pages/watchlist_movies_page.dart';
import 'package:core/features/tvshow/presentation/bloc/watchlist_tvshow_bloc.dart';
import 'package:core/features/tvshow/presentation/pages/watchlist_tvshow_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  late TabController controller;

  final _listBottomItem = [
    BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movie'),
    BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'TvShow')
  ];

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

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<AllWatchlistMoviesBloc>().add(FetchAllWatchlistMovies()));
    Future.microtask(() => context
        .read<AllWatchlistTvShowsBloc>()
        .add(FetchAllWatchlistTvShows()));
    _pageController =
        PageController(initialPage: _currentIndex, keepPage: true);
    controller = TabController(vsync: this, length: pages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildMyAppBar(),
      body: TabBarView(
        controller: controller,
        children: [WatchlistMoviesPage(), WatchlistTvShowsPage()],
      ),
    );
  }

  AppBar _buildMyAppBar() {
    return AppBar(
      title: const Text('Your Watchlist'),
      bottom: TabBar(controller: controller, tabs: tabs),
    );
  }

  void pageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
}
