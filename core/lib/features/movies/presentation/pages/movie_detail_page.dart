import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/movie-detail';

  final int id;
  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<MovieRecommendationBloc>()
        .add(FetchMovieRecommendation(widget.id)));
    Future.microtask(() => context
        .read<MovieWatchlistBloc>()
        .add(LoadMovieWatchlistStatus(widget.id)));
    Future.microtask(
        () => context.read<MovieDetailBloc>().add(FetchMovieDetail(widget.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
      builder: (context, state) {
        if (state is MovieDetailLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MovieDetailLoaded) {
          return DetailContent(state.movie);
        } else if (state is MovieDetailFailure) {
          return Text(state.message);
        } else {
          return Container();
        }
      },
    ));
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;

  DetailContent(this.movie);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
                              movie.title,
                              style: kHeading5,
                            ),
                            BlocConsumer<MovieWatchlistBloc, MovieDetailState>(
                                listener: (context, state) {
                              if (state is AddedToWatchlistSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.message)));
                              } else if (state is AddedToWatchlistFailure) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(state.message),
                                      );
                                    });
                              } else if (state is RemoveWatchlistSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.message)));
                              } else if (state is RemoveWatchlistFailure) {
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
                              if (state is IsAddedToWatchListStatus) {
                                status = state.status;
                              }
                              return ElevatedButton(
                                onPressed: () async {
                                  if (state is IsAddedToWatchListStatus) {
                                    if (!state.status) {
                                      context
                                          .read<MovieWatchlistBloc>()
                                          .add(AddMovieWatchlist(movie));
                                    } else {
                                      context
                                          .read<MovieWatchlistBloc>()
                                          .add(RemoveMovieWatchlist(movie));
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
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<MovieRecommendationBloc,
                                MovieDetailState>(builder: (context, state) {
                              if (state is MovieRecommendationsLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is MovieRecommendationsFailure) {
                                return Text(state.message);
                              } else if (state is MovieRecommendationsLoaded) {
                                return Container(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final movie =
                                          state.movieRecommendation[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              MovieDetailPage.ROUTE_NAME,
                                              arguments: movie.id,
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: state.movieRecommendation.length,
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

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
