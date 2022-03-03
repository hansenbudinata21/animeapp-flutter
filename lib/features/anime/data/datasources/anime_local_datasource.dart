import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';
import '../models/anime_model.dart';

abstract class AnimeLocalDataSource {
  /// Gets the cached data for /OngoingSeries
  ///
  /// Throws [CacheException] for all errors codes
  Future<List<AnimeModel>> getOngoingAnimes();
  Future<void> cacheOngoingAnimes(List<AnimeModel> animesToCache);

  /// Gets the cached data for /Popular/:page
  ///
  /// Throws [CacheException] for all errors codes
  Future<List<AnimeModel>> getPopularAnimes();
  Future<void> cachePopularAnimes(List<AnimeModel> animesToCache);

  /// Gets the cached data for /RecentlyAddedSeries
  ///
  /// Throws [CacheException] for all errors codes
  Future<List<AnimeModel>> getRecentlyAddedAnimes();
  Future<void> cacheRecentlyAddedAnimes(List<AnimeModel> animesToCache);

  /// Gets the cached data for /RecentReleaseEpisodes/:page
  ///
  /// Throws [CacheException] for all errors codes
  Future<List<AnimeModel>> getRecentlyReleasedEpisodes();
  Future<void> cacheRecentlyReleasedEpisodes(List<AnimeModel> animesToCache);
}

class AnimeLocalDataSourceImpl implements AnimeLocalDataSource {
  final SharedPreferences sharedPreferences;
  AnimeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheOngoingAnimes(List<AnimeModel> animesToCache) async {
    await sharedPreferences.setString("ONGOING_ANIMES", jsonEncode(animesToCache));
  }

  @override
  Future<void> cachePopularAnimes(List<AnimeModel> animesToCache) async {
    await sharedPreferences.setString("POPULAR_ANIMES", jsonEncode(animesToCache));
  }

  @override
  Future<void> cacheRecentlyAddedAnimes(List<AnimeModel> animesToCache) async {
    await sharedPreferences.setString("RECENTLY_ADDED_ANIMES", jsonEncode(animesToCache));
  }

  @override
  Future<void> cacheRecentlyReleasedEpisodes(List<AnimeModel> animesToCache) async {
    await sharedPreferences.setString("RECENTLY_RELEASED_EPISODES", jsonEncode(animesToCache));
  }

  @override
  Future<List<AnimeModel>> getOngoingAnimes() {
    String? jsonString = sharedPreferences.getString("ONGOING_ANIMES");
    if (jsonString != null) {
      return Future.value(jsonDecode(jsonString).map<AnimeModel>((json) => AnimeModel.fromJson(json)).toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<AnimeModel>> getPopularAnimes() {
    String? jsonString = sharedPreferences.getString("POPULAR_ANIMES");
    if (jsonString != null) {
      return Future.value(jsonDecode(jsonString).map<AnimeModel>((json) => AnimeModel.fromJson(json)).toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<AnimeModel>> getRecentlyAddedAnimes() {
    String? jsonString = sharedPreferences.getString("RECENTLY_ADDED_ANIMES");
    if (jsonString != null) {
      return Future.value(jsonDecode(jsonString).map<AnimeModel>((json) => AnimeModel.fromJson(json)).toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<AnimeModel>> getRecentlyReleasedEpisodes() {
    String? jsonString = sharedPreferences.getString("RECENTLY_RELEASED_EPISODES");
    if (jsonString != null) {
      return Future.value(jsonDecode(jsonString).map<AnimeModel>((json) => AnimeModel.fromJson(json)).toList());
    } else {
      throw CacheException();
    }
  }
}
