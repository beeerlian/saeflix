import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/features/tvshow/domain/entities/tvshow_detail.dart';
import 'package:core/features/tvshow/domain/entities/tvshow_genre.dart';
import 'package:core/features/tvshow/presentation/bloc/tvshow_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TvShowDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tvshow-detail';

  final int id;
  TvShowDetailPage({required this.id});

  @override
  _TvShowDetailPageState createState() => _TvShowDetailPageState();
}

class _TvShowDetailPageState extends State<TvShowDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<TvShowRecommendationBloc>()
        .add(FetchTvShowRecommendation(widget.id)));
    Future.microtask(() => context
        .read<TvShowWatchlistBloc>()
        .add(LoadTvShowWatchlistStatus(widget.id)));
    Future.microtask(() =>
        context.read<TvShowDetailBloc>().add(FetchTvShowDetail(widget.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<TvShowDetailBloc, TvShowDetailState>(
      builder: (context, state) {
        if (state is TvShowDetailLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvShowDetailLoaded) {
          return TvShowDetailContent(state.tvShow);
        } else if (state is TvShowDetailFailure) {
          return Text(state.message);
        } else {
          return Container();
        }
      },
    ));
  }
}

class TvShowDetailContent extends StatelessWidget {
  final TvShowDetail tvshow;

  TvShowDetailContent(this.tvshow);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvshow.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvshow.name.toString(),
                              style: kHeading5,
                            ),
                            BlocConsumer<TvShowWatchlistBloc,
                                TvShowDetailState>(listener: (context, state) {
                              if (state is AddTvShowToWatchlistSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.message)));
                              } else if (state is AddTvShowToWatchlistFailure) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(state.message),
                                      );
                                    });
                              } else if (state
                                  is RemoveTvShowWatchlistSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.message)));
                              } else if (state
                                  is RemoveTvShowWatchlistFailure) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(state.message),
                                      );
                                    });
                              }
                            }, builder: (context, state) {
                              bool status = false;
                              if (state is IsAddedTvShowToWatchListStatus) {
                                status = state.status;
                              }
                              return ElevatedButton(
                                onPressed: () async {
                                  if (state is IsAddedTvShowToWatchListStatus) {
                                    if (!state.status) {
                                      context
                                          .read<TvShowWatchlistBloc>()
                                          .add(AddTvShowWatchlist(tvshow));
                                    } else {
                                      context.read<TvShowWatchlistBloc>().add(
                                          RemoveTvShowWatchlistEvent(tvshow));
                                    }
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    status
                                        ? const Icon(Icons.check)
                                        : const Icon(Icons.add),
                                    const Text('Watchlist'),
                                  ],
                                ),
                              );
                            }),
                            Text(
                              _showGenres(tvshow.genres as List<TvShowGenre>),
                            ),
                            Text(
                              _showDuration(tvshow.firstAirDate.toString()),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvshow.voteAverage! / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvshow.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvshow.overview.toString(),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvShowRecommendationBloc,
                                TvShowDetailState>(builder: (context, state) {
                              if (state is TvShowRecommendationsLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state
                                  is TvShowRecommendationsFailure) {
                                return Text(state.message);
                              } else if (state is TvShowRecommendationsLoaded) {
                                return Container(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final tvShow =
                                          state.tvShowRecommendation[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              TvShowDetailPage.ROUTE_NAME,
                                              arguments: tvShow.id,
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount:
                                        state.tvShowRecommendation.length,
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            })
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<TvShowGenre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(String firstAirDate) {
    return '${firstAirDate}m';
  }
}
