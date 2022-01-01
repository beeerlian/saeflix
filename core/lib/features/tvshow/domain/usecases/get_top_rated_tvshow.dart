import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/repositories/tvshow_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetTopRatedTvShow {
  final TvShowRepository repository;

  GetTopRatedTvShow(this.repository);

  Future<Either<Failure, List<TvShow>>> execute(){
    return repository.getTopRatedTvShow();
  }
}