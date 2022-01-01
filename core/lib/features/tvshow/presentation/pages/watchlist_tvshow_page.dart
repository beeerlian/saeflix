import 'package:core/features/tvshow/presentation/bloc/watchlist_tvshow_bloc.dart';
import 'package:core/features/tvshow/presentation/widgets/tvshow_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTvShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tvShow';

  @override
  _WatchlistTvShowsPageState createState() => _WatchlistTvShowsPageState();
}

class _WatchlistTvShowsPageState extends State<WatchlistTvShowsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Tv Show Watchlist'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AllWatchlistTvShowsBloc, WatchlistTvShowsState>(
          builder: (context, state) {
            if (state is WatchlistTvShowsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistTvShowsLoaded) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      childAspectRatio: 3 / 5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8),
                  itemCount: state.tvShow.length,
                  itemBuilder: (context, index) {
                    final tvShow = state.tvShow[index];
                    return TvShowCard(tvShow);
                  });
            } else if (state is WatchlistTvShowsFailed) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
