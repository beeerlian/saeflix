import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:flutter/material.dart';

class TvShowCard extends StatelessWidget {
  final TvShow tvShow;

  TvShowCard(this.tvShow);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            TvShowDetailPage.ROUTE_NAME,
            arguments: tvShow.id,
          );
        },
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvShow.posterPath}',
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
                    tvShow.name ?? '-',
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
