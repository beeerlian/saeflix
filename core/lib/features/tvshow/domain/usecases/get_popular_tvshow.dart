
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/repositories/tvshow_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetPopularTvShow {
  final TvShowRepository repository;

  GetPopularTvShow(this.repository);

  Future<Either<Failure, List<TvShow>>> execute(){
    return repository.getPopularTvShow();
  }
}