import 'package:core/features/movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<AllPopularMoviesBloc>().add(FetchAllPopularMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<AllPopularMoviesBloc, PopularMoviesState>(
            builder: (context, state) {
              if (state is PopularMoviesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PopularMoviesLoaded) {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150,
                            childAspectRatio: 3 / 5,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final tvShow = state.movies[index];
                      return MovieCard(tvShow);
                    });
              } else if (state is PopularMoviesFailed) {
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
