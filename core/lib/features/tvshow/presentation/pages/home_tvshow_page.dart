import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/presentation/bloc/tvshow_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTvShowPage extends StatefulWidget {
  const HomeTvShowPage({Key? key}) : super(key: key);

  static const ROUTE_NAME = '/home-tvshow';

  @override
  _HomeTvShowPageState createState() => _HomeTvShowPageState();
}

class _HomeTvShowPageState extends State<HomeTvShowPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Now Playing',
              style: kHeading6,
            ),
            BlocBuilder<NowPlayingTvShowBloc, TvShowListState>(
                builder: (context, state) {
              if (state is NowPlayingTvShowListLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is NowPlayingTvShowListLoaded) {
                return TvShowList(state.tvShows);
              } else {
                return Text('Failed');
              }
            }),
            _buildSubHeading(
              title: 'Popular',
              onTap: () =>
                  Navigator.pushNamed(context, PopularTvShowsPage.ROUTE_NAME),
            ),
            BlocBuilder<TopRatedTvShowBloc, TvShowListState>(
                builder: (context, state) {
              if (state is TopRatedTvShowListLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TopRatedTvShowListLoaded) {
                return TvShowList(state.tvShows);
              } else {
                return Text('Failed');
              }
            }),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () =>
                  Navigator.pushNamed(context, TopRatedTvShowsPage.ROUTE_NAME),
            ),
            BlocBuilder<PopularTvShowBloc, TvShowListState>(
                builder: (context, state) {
              if (state is PopularTvShowListLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PopularTvShowListLoaded) {
                return TvShowList(state.tvShows);
              } else {
                return const Text('Failed');
              }
            }),
          ],
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvShowList extends StatelessWidget {
  final List<TvShow> tvshows;

  TvShowList(this.tvshows);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvshow = tvshows[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvShowDetailPage.ROUTE_NAME,
                  arguments: tvshow.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvshow.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvshows.length,
      ),
    );
  }
}
