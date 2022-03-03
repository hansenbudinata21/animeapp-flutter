import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/urls.dart';
import '../../../../core/error/exception.dart';
import '../models/anime_model.dart';

abstract class AnimeRemoteDataSource {
  /// Calls /Search/:title
  ///
  /// Throws [ServerException] for all errors codes
  Future<List<AnimeModel>> getAnimesByTitle({required String title});

  /// Calls /AnimeEpisodeHandler/:id
  ///
  /// Throws [ServerException] for all errors codes
  Future<List<String>> getIframeUrlsById({required String id});

  /// Calls /OngoingSeries
  ///
  /// Throws [ServerException] for all errors codes
  Future<List<AnimeModel>> getOngoingAnimes();

  /// Calls /Popular/:page
  ///
  /// Throws [ServerException] for all errors codes
  Future<List<AnimeModel>> getPopularAnimes({required int page});

  /// Calls /RecentlyAddedSeries
  ///
  /// Throws [ServerException] for all errors codes
  Future<List<AnimeModel>> getRecentlyAddedAnimes();

  /// Calls /RecentReleaseEpisodes/:page
  ///
  /// Throws [ServerException] for all errors codes
  Future<List<AnimeModel>> getRecentlyReleasedEpisodes({required int page});
}

class AnimeRemoteDataSourceImpl implements AnimeRemoteDataSource {
  final http.Client httpClient;
  AnimeRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<List<AnimeModel>> getAnimesByTitle({required String title}) async {
    final http.Response response = await httpClient.get(Uri.parse("${Urls.remoteEndpoint}/Search/$title"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["search"].map<AnimeModel>((json) => AnimeModel.fromJson(json)).toList();
    } else {
      throw ServerException(statusCode: response.statusCode, statusMessage: response.reasonPhrase ?? "Not Connected to Remote Data Source");
    }
  }

  @override
  Future<List<String>> getIframeUrlsById({required String id}) async {
    final http.Response response = await httpClient.get(Uri.parse("${Urls.remoteEndpoint}/AnimeEpisodeHandler/$id"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["anime"][0]["servers"].map<String>((json) => json["iframe"].toString()).toList();
    } else {
      throw ServerException(statusCode: response.statusCode, statusMessage: response.reasonPhrase ?? "Not Connected to Remote Data Source");
    }
  }

  @override
  Future<List<AnimeModel>> getOngoingAnimes() async {
    final http.Response response = await httpClient.get(Uri.parse("${Urls.remoteEndpoint}/OngoingSeries"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["anime"].map<AnimeModel>((json) => AnimeModel.fromJson(json)).toList();
    } else {
      throw ServerException(statusCode: response.statusCode, statusMessage: response.reasonPhrase ?? "Not Connected to Remote Data Source");
    }
  }

  @override
  Future<List<AnimeModel>> getPopularAnimes({required int page}) async {
    final http.Response response = await httpClient.get(Uri.parse("${Urls.remoteEndpoint}/Popular/$page"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["popular"].map<AnimeModel>((json) => AnimeModel.fromJson(json)).toList();
    } else {
      throw ServerException(statusCode: response.statusCode, statusMessage: response.reasonPhrase ?? "Not Connected to Remote Data Source");
    }
  }

  @override
  Future<List<AnimeModel>> getRecentlyAddedAnimes() async {
    final http.Response response = await httpClient.get(Uri.parse("${Urls.remoteEndpoint}/RecentlyAddedSeries"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["anime"].map<AnimeModel>((json) => AnimeModel.fromJson(json)).toList();
    } else {
      throw ServerException(statusCode: response.statusCode, statusMessage: response.reasonPhrase ?? "Not Connected to Remote Data Source");
    }
  }

  @override
  Future<List<AnimeModel>> getRecentlyReleasedEpisodes({required int page}) async {
    final http.Response response = await httpClient.get(Uri.parse("${Urls.remoteEndpoint}/RecentReleaseEpisodes/$page"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["anime"].map<AnimeModel>((json) => AnimeModel.fromJson(json)).toList();
    } else {
      throw ServerException(statusCode: response.statusCode, statusMessage: response.reasonPhrase ?? "Not Connected to Remote Data Source");
    }
  }
}
