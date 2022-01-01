import 'package:core/features/tvshow/domain/entities/tvshow_detail.dart';
import 'package:core/features/tvshow/domain/repositories/tvshow_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class RemoveTvShowWatchList {
  final TvShowRepository repository;

  RemoveTvShowWatchList(this.repository);

  Future<Either<Failure, String>> execute(TvShowDetail tvShow) {
    return repository.removeTvShowWatchList(tvShow);
  }
}
