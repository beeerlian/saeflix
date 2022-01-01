import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:search/features/tvshow/presentation/bloc/search_tvshow_bloc.dart';

class TvShowSearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search-tvshow';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search TvShow'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context
                    .read<SearchTvshowBloc>()
                    .add(OnTvShowQueryChanged(query));

                // Provider.of<TvShowSearchNotifier>(context, listen: false)
                //     .fetchTvShowSearch(query);
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
            BlocBuilder<SearchTvshowBloc, SearchTvshowState>(
              builder: (context, state) {
                if (state is SearchTvShowLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchTvShowHasData) {
                  final result = state.results;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tvshow = result[index];
                        return TvShowCard(tvshow);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is SearchTvShowError) {
                  return Center(child: Text(state.message));
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
