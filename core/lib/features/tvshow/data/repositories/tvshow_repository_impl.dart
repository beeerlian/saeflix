import 'dart:io';

import 'package:core/features/tvshow/data/datasources/local_tvshow_datasource.dart';
import 'package:core/features/tvshow/data/datasources/remote_tvshow_datasource.dart';
import 'package:core/features/tvshow/data/models/tvshow_table.dart';
import 'package:core/features/tvshow/domain/entities/tvshow.dart';
import 'package:core/features/tvshow/domain/entities/tvshow_detail.dart';
import 'package:core/features/tvshow/domain/repositories/tvshow_repository.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/network_info.dart';
import 'package:dartz/dartz.dart';

class TvShowRepositoryImpl implements TvShowRepository {
  final TvShowRemoteDataSource remoteDatasource;
  final TvShowLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TvShowRepositoryImpl(
      {required this.remoteDatasource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<TvShow>>> getNowPlayingTvShow() async {
    networkInfo.isConnected;
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.getNowPlayingTvShow();
        localDataSource.cacheNowPlayingTvShows(
            result.map((tvshow) => TvShowTable.fromDTO(tvshow)).toList());
        return Right(result.map((e) => e.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure(''));
      } on SocketException {
        return Left(ConnectionFailure('Failed to connect to network'));
      }
    } else {
      try {
        final result = await localDataSource.getCachedNowPlayingTvShows();
        return Right(result.map((model) => model.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<TvShow>>> getPopularTvShow() async {
    try {
      final result = await remoteDatasource.getPopularTvShow();
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TvShow>>> getTopRatedTvShow() async {
    try {
      final result = await remoteDatasource.getTopRatedTvShow();
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, TvShowDetail>> getTvShowDetail(int id) async {
    try {
      final result = await remoteDatasource.getTvShowDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TvShow>>> getTvShowRecommendation(int id) async {
    try {
      final result = await remoteDatasource.getTvShowRecommendation(id);
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<bool> getTvShowWatchListStatus(int id) async {
    final result = await localDataSource.getTvShowById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<TvShow>>> getWatchListTvShow() async {
    final result = await localDataSource.getWatchlistTvShows();
    return Right(result.map((e) => e.toEntity()).toList());
  }

  @override
  Future<Either<Failure, String>> removeTvShowWatchList(
      TvShowDetail tvShow) async {
    try {
      final result =
          await localDataSource.removeWatchlist(TvShowTable.fromEntity(tvShow));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveTvShowWatchList(
      TvShowDetail tvShow) async {
    try {
      final result =
          await localDataSource.insertWatchlist(TvShowTable.fromEntity(tvShow));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<TvShow>>> searchTvShow(String query) async {
    try {
      final result = await remoteDatasource.searchTvShow(query);
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
