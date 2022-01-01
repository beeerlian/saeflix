import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/features/movies/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  MovieCard(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            MovieDetailPage.ROUTE_NAME,
            arguments: movie.id,
          );
        },
        child: Container(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  // width: MediaQuery.of(context).size.width / 3,
                  height: 250,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Align(
                alignment: Alignment(0, 1),
                child: Container(
                  padding: EdgeInsets.all(4),
                  width: double.infinity,
                  color: Colors.grey.shade800.withOpacity(0.8),
                  child: Text(
                    movie.title ?? '-',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: kBodyText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
