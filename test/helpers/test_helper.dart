import 'package:core/features/movies/data/datasources/db/database_helper.dart';
import 'package:core/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:core/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:core/features/movies/domain/repositories/movie_repository.dart';
import 'package:core/features/tvshow/data/datasources/local_tvshow_datasource.dart';
import 'package:core/features/tvshow/data/datasources/remote_tvshow_datasource.dart';
import 'package:core/features/tvshow/domain/repositories/tvshow_repository.dart';
import 'package:core/utils/network_info.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  TvShowRepository,
  TvShowRemoteDataSource,
  TvShowLocalDataSource,
  DatabaseHelper,
  NetworkInfo
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
