import 'package:core/features/tvshow/presentation/bloc/popular_tvshow_bloc.dart';
import 'package:core/features/tvshow/presentation/widgets/tvshow_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularTvShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tvshow';

  @override
  _PopularTvShowsPageState createState() => _PopularTvShowsPageState();
}

class _PopularTvShowsPageState extends State<PopularTvShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<AllPopularTvShowsBloc>().add(FetchAllPopularTvShows()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TvShows'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<AllPopularTvShowsBloc, PopularTvShowsState>(
            builder: (context, state) {
              if (state is PopularTvShowsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PopularTvShowsLoaded) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final movie = state.movies[index];
                    return TvShowCard(movie);
                  },
                  itemCount: state.movies.length,
                );
              } else if (state is PopularTvShowsFailed) {
                return Center(
                  key: Key('error_message'),
                  child: Text(state.message),
                );
              } else {
                return Container();
              }
            },
          )),
    );
  }
}
