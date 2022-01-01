import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/entities/tvshow_detail.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

abstract class TvShowRepository {
  Future<Either<Failure, List<TvShow>>> getNowPlayingTvShow();
  Future<Either<Failure, List<TvShow>>> getPopularTvShow();
  Future<Either<Failure, List<TvShow>>> getTopRatedTvShow();
  Future<Either<Failure, TvShowDetail>> getTvShowDetail(int id);
  Future<Either<Failure, List<TvShow>>> getTvShowRecommendation(int id);
  Future<Either<Failure, List<TvShow>>> searchTvShow(String query);
  Future<Either<Failure, String>> saveTvShowWatchList(
      TvShowDetail tvShow);
  Future<Either<Failure, String>> removeTvShowWatchList(
      TvShowDetail tvShow);
  Future<bool> getTvShowWatchListStatus(int id);
  Future<Either<Failure, List<TvShow>>> getWatchListTvShow();
}
