import 'dart:convert';

import 'package:animeapp/core/error/exception.dart';
import 'package:animeapp/features/anime/data/datasources/anime_local_datasource.dart';
import 'package:animeapp/features/anime/data/models/anime_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AnimeLocalDataSource dataSource;
  late MockSharedPreferences mockSharedPreferences;
  List<AnimeModel> tAnimeModels = [
    const AnimeModel(
      title: "Boruto: Naruto Next Generations",
      imageUrl: "https://gogocdn.net/cover/boruto-naruto-next-generations.png",
      synopsis: "Plot Summary: Naruto was a young shinobi with an incorrigible knack for mischief. He achieved his dream to become the greatest ninja in the village and his face sits atop the Hokage monument. But this is not his story... A new generation of ninja are ready to take the stage, led by Naruto's own son, Boruto!",
      genres: ["action", "adventure", "martial-arts", "shounen", "super-power"],
      category: "Spring 2017 Anime",
      status: "Ongoing",
      releasedYear: 2017,
      totalEpisodes: 237,
    )
  ];

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = AnimeLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  test("Cache Ongoing Animes should call GetStorage to write the data", () {
    when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) => Future.value(true));
    dataSource.cacheOngoingAnimes(tAnimeModels);
    verify(() => mockSharedPreferences.setString("ONGOING_ANIMES", jsonEncode(tAnimeModels)));
  });

  test("Cache Popular Animes should call GetStorage to write the data", () {
    when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) => Future.value(true));
    dataSource.cachePopularAnimes(tAnimeModels);
    verify(() => mockSharedPreferences.setString("POPULAR_ANIMES", jsonEncode(tAnimeModels)));
  });

  test("Cache Recently Added Animes should call GetStorage to write the data", () {
    when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) => Future.value(true));
    dataSource.cacheRecentlyAddedAnimes(tAnimeModels);
    verify(() => mockSharedPreferences.setString("RECENTLY_ADDED_ANIMES", jsonEncode(tAnimeModels)));
  });

  test("Cache Recently Released Animes should call GetStorage to write the data", () {
    when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) => Future.value(true));
    dataSource.cacheRecentlyReleasedEpisodes(tAnimeModels);
    verify(() => mockSharedPreferences.setString("RECENTLY_RELEASED_EPISODES", jsonEncode(tAnimeModels)));
  });

  group("Get Ongoing Animes", () {
    test("should call GetStorage to read the data", () {
      when(() => mockSharedPreferences.getString(any())).thenReturn(jsonEncode(tAnimeModels));
      dataSource.getOngoingAnimes();
      verify(() => mockSharedPreferences.getString("ONGOING_ANIMES"));
    });

    test("should return List<Anime> if data exists", () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(jsonEncode(tAnimeModels));
      List<AnimeModel> result = await dataSource.getOngoingAnimes();
      expect(listEquals(result, tAnimeModels), true);
    });

    test("should throw CacheException if data does not exists", () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      expect(() => dataSource.getOngoingAnimes(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group("Get Popular Animes", () {
    test("should call GetStorage to read the data", () {
      when(() => mockSharedPreferences.getString(any())).thenReturn(jsonEncode(tAnimeModels));
      dataSource.getPopularAnimes();
      verify(() => mockSharedPreferences.getString("POPULAR_ANIMES"));
    });

    test("should return List<Anime> if data exists", () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(jsonEncode(tAnimeModels));
      List<AnimeModel> result = await dataSource.getPopularAnimes();
      expect(listEquals(result, tAnimeModels), true);
    });

    test("should throw CacheException if data does not exists", () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      expect(() => dataSource.getPopularAnimes(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group("Get Recently Added Animes", () {
    test("should call GetStorage to read the data", () {
      when(() => mockSharedPreferences.getString(any())).thenReturn(jsonEncode(tAnimeModels));
      dataSource.getRecentlyAddedAnimes();
      verify(() => mockSharedPreferences.getString("RECENTLY_ADDED_ANIMES"));
    });

    test("should return List<Anime> if data exists", () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(jsonEncode(tAnimeModels));
      List<AnimeModel> result = await dataSource.getRecentlyAddedAnimes();
      expect(listEquals(result, tAnimeModels), true);
    });

    test("should throw CacheException if data does not exists", () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      expect(() => dataSource.getRecentlyAddedAnimes(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group("Get Recently Released Episodes", () {
    test("should call GetStorage to read the data", () {
      when(() => mockSharedPreferences.getString(any())).thenReturn(jsonEncode(tAnimeModels));
      dataSource.getRecentlyReleasedEpisodes();
      verify(() => mockSharedPreferences.getString("RECENTLY_RELEASED_EPISODES"));
    });

    test("should return List<Anime> if data exists", () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(jsonEncode(tAnimeModels));
      List<AnimeModel> result = await dataSource.getRecentlyReleasedEpisodes();
      expect(listEquals(result, tAnimeModels), true);
    });

    test("should throw CacheException if data does not exists", () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      expect(() => dataSource.getRecentlyReleasedEpisodes(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
}
