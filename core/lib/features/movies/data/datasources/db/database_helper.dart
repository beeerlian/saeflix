import 'dart:async';

import 'package:core/common/encrypt.dart';
import 'package:core/features/movies/data/models/movie_table.dart';
import 'package:core/features/tvshow/data/models/tvshow_table.dart';
import 'package:sqflite_sqlcipher/sqflite.dart' as sqf;

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static sqf.Database? _database;

  Future<sqf.Database?> get database async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database;
  }

  static const String _tblWatchlist = 'watchlist';
  static const String _tblCache = 'cache';
  static const String _tblWatchlistTvShow = 'tvshow_watchlist';
  static const String _tblCacheTvShow = 'tvshow_cache';

  Future<sqf.Database> _initDb() async {
    final path = await sqf.getDatabasesPath();
    final databasePath = '$path/saeflix.db';

    var db = await sqf.openDatabase(databasePath,
        version: 1,
        onCreate: _onCreate,
        password: encrypt('Your secure password...'));
    return db;
  }

  void _onCreate(sqf.Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE  $_tblCache (
        id INTEGER PRIMARY KEY,
        title TEXT,
        name TEXT,
        overview TEXT,
        posterPath TEXT,
        category TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE  $_tblWatchlistTvShow (
        id INTEGER PRIMARY KEY,
        title TEXT,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE  $_tblCacheTvShow (
        id INTEGER PRIMARY KEY,
        title TEXT,
        name TEXT,
        overview TEXT,
        posterPath TEXT,
        category TEXT
      );
    ''');
  }

  Future<void> insertCacheTransaction(
      List<MovieTable> movies, String category) async {
    final db = await database;
    db!.transaction((txn) async {
      for (final movie in movies) {
        final movieJson = movie.toJson();
        movieJson['category'] = category;
        txn.insert(_tblCache, movieJson);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCacheMovies(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblCache,
      where: 'category = ?',
      whereArgs: [category],
    );

    return results;
  }

  Future<int> clearCache(String category) async {
    final db = await database;
    return await db!.delete(
      _tblCache,
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  Future<int> insertWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, movie.toJson());
  }

  Future<int> removeWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlist);

    return results;
  }

  //------------------------- TvShows --------------------------------------------------//
  Future<void> insertCacheTransactionTvShow(
      List<TvShowTable> tvShows, String category) async {
    final db = await database;
    db!.transaction((txn) async {
      for (final tvShow in tvShows) {
        final tvshowJson = tvShow.toJson();
        tvshowJson['category'] = category;
        txn.insert(_tblCacheTvShow, tvshowJson);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCacheTvShow(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblCacheTvShow,
      where: 'category = ?',
      whereArgs: [category],
    );

    return results;
  }

  Future<int> clearCacheTvShow(String category) async {
    final db = await database;
    return await db!.delete(
      _tblCacheTvShow,
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  Future<int> insertWatchlistTvShow(TvShowTable tvShow) async {
    final db = await database;
    return await db!.insert(_tblWatchlistTvShow, tvShow.toJson());
  }

  Future<int> removeWatchlistTvShow(TvShowTable tvShow) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlistTvShow,
      where: 'id = ?',
      whereArgs: [tvShow.id],
    );
  }

  Future<Map<String, dynamic>?> getTvShowById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlistTvShow,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvShows() async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db!.query(_tblWatchlistTvShow);

    return results;
  }
}
