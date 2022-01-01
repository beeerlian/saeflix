import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/repositories/tvshow_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetNowPlayingTvShow {
  final TvShowRepository repository;

  GetNowPlayingTvShow(this.repository);

  Future<Either<Failure, List<TvShow>>> execute() {
    return repository.getNowPlayingTvShow();
  }
}
