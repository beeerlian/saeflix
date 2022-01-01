import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../search.dart';

class MovieSearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/movie-search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchMovieBloc>().add(OnMovieQueryChanged(query));

                // Provider.of<MovieSearchNotifier>(context, listen: false)
                //     .fetchMovieSearch(query);
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchMovieBloc, SearchMovieState>(
              builder: (context, state) {
                if (state is SearchMovieLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchMovieHasData) {
                  final result = state.results;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final movie = state.results[index];
                        return MovieCard(movie);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is SearchMovieError) {
                  return Expanded(
                    child: Center(
                      child: Text(state.message),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
