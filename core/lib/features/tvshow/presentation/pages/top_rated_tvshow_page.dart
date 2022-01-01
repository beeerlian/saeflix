import 'package:core/features/tvshow/presentation/bloc/top_rated_tvshow_bloc.dart';
import 'package:core/features/tvshow/presentation/widgets/tvshow_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TopRatedTvShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tvshow';

  @override
  _TopRatedTvShowsPageState createState() => _TopRatedTvShowsPageState();
}

class _TopRatedTvShowsPageState extends State<TopRatedTvShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<AllTopRatedTvShowsBloc>().add(FetchAllTopRatedTvShows()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated TvShows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AllTopRatedTvShowsBloc, TopRatedTvShowsState>(
          builder: (context, state) {
            if (state is TopRatedTvShowsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvShowsLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShow = state.tvShows[index];
                  return TvShowCard(tvShow);
                },
                itemCount: state.tvShows.length,
              );
            } else if (state is TopRatedTvShowsFailed) {
              return Center(
                key: Key('error_message'),
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
