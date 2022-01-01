import 'package:core/features/movies/data/datasources/db/database_helper.dart';
import 'package:core/features/tvshow/data/models/tvshow_table.dart';
import 'package:core/utils/exception.dart';


abstract class TvShowLocalDataSource {
  Future<String> insertWatchlist(TvShowTable tvShow);
  Future<String> removeWatchlist(TvShowTable tvShow);
  Future<TvShowTable?> getTvShowById(int id);
  Future<List<TvShowTable>> getWatchlistTvShows();
  Future<void> cacheNowPlayingTvShows(List<TvShowTable> tvShows);
  Future<List<TvShowTable>> getCachedNowPlayingTvShows();
}

class TvShowLocalDataSourceImpl implements TvShowLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvShowLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<void> cacheNowPlayingTvShows(List<TvShowTable> tvShows) async {
    await databaseHelper.clearCacheTvShow('now playing');
    await databaseHelper.insertCacheTransactionTvShow(tvShows, 'now playing');
  }

  @override
  Future<List<TvShowTable>> getCachedNowPlayingTvShows() async {
    final result = await databaseHelper.getCacheTvShow('now playing');
    if (result.length > 0) {
      return result.map((data) => TvShowTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }

  @override
  Future<TvShowTable?> getTvShowById(int id) async {
    final result = await databaseHelper.getTvShowById(id);
    if (result != null) {
      return TvShowTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvShowTable>> getWatchlistTvShows() async {
    final result = await databaseHelper.getWatchlistTvShows();
    return result.map((data) => TvShowTable.fromMap(data)).toList();
  }

  @override
  Future<String> insertWatchlist(TvShowTable tvShow) async {
    try {
      await databaseHelper.insertWatchlistTvShow(tvShow);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TvShowTable tvShow) async {
    try {
      await databaseHelper.removeWatchlistTvShow(tvShow);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
