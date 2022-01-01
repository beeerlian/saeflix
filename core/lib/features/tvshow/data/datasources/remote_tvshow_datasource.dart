import 'dart:convert';
import 'dart:io';

import 'package:core/features/tvshow/data/models/tvshow_detail_model.dart';
import 'package:core/features/tvshow/data/models/tvshow_model.dart';
import 'package:core/features/tvshow/data/models/tvshows_response.dart';
import 'package:core/utils/exception.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

abstract class TvShowRemoteDataSource {
  Future<List<TvShowModel>> getNowPlayingTvShow();
  Future<List<TvShowModel>> getPopularTvShow();
  Future<List<TvShowModel>> getTopRatedTvShow();
  Future<TvShowDetailResponse> getTvShowDetail(int id);
  Future<List<TvShowModel>> getTvShowRecommendation(int id);
  Future<List<TvShowModel>> searchTvShow(String query);
}

class TvShowRemoteDataSourceImpl implements TvShowRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvShowRemoteDataSourceImpl(this.client);

  Future<IOClient> createioClientWithSSLCertificationChecking(
      {required String certificate}) async {
    final sslCert = await rootBundle.load(certificate);
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    securityContext;
    HttpClient client = HttpClient(context: securityContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return IOClient(client);
  }

  @override
  Future<List<TvShowModel>> getNowPlayingTvShow() async {
    IOClient ioClient = await createioClientWithSSLCertificationChecking(
        certificate: "core/assets/cer/moviedb.pem");
    final response =
        await ioClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));
    if (response.statusCode != 200)
      throw ServerException();
    else
      return TvShowResponse.fromJson(jsonDecode(response.body)).tvShowList;
  }

  @override
  Future<List<TvShowModel>> getPopularTvShow() async {
    IOClient ioClient = await createioClientWithSSLCertificationChecking(
        certificate: "core/assets/cer/moviedb.pem");
    final response =
        await ioClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));
    if (response.statusCode != 200)
      throw ServerException();
    else
      return TvShowResponse.fromJson(jsonDecode(response.body)).tvShowList;
  }

  @override
  Future<List<TvShowModel>> getTopRatedTvShow() async {
    IOClient ioClient = await createioClientWithSSLCertificationChecking(
        certificate: "core/assets/cer/moviedb.pem");
    final response =
        await ioClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));
    if (response.statusCode != 200)
      throw ServerException();
    else
      return TvShowResponse.fromJson(jsonDecode(response.body)).tvShowList;
  }

  @override
  Future<TvShowDetailResponse> getTvShowDetail(int id) async {
    IOClient ioClient = await createioClientWithSSLCertificationChecking(
        certificate: "core/assets/cer/moviedb.pem");

    final response = await ioClient.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));
    if (response.statusCode != 200)
      throw ServerException();
    else
      return TvShowDetailResponse.fromJson(jsonDecode(response.body));
  }

  @override
  Future<List<TvShowModel>> getTvShowRecommendation(int id) async {
    IOClient ioClient = await createioClientWithSSLCertificationChecking(
        certificate: "core/assets/cer/moviedb.pem");
    final response = await ioClient
        .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));
    if (response.statusCode != 200)
      throw ServerException();
    else
      return TvShowResponse.fromJson(jsonDecode(response.body)).tvShowList;
  }

  @override
  Future<List<TvShowModel>> searchTvShow(String query) async {
    IOClient ioClient = await createioClientWithSSLCertificationChecking(
        certificate: "core/assets/cer/moviedb.pem");
    final response = await ioClient
        .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'));
    if (response.statusCode != 200)
      throw ServerException();
    else
      return TvShowResponse.fromJson(jsonDecode(response.body)).tvShowList;
  }
}
