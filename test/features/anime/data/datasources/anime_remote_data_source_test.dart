import 'dart:convert';
import 'dart:io';

import 'package:animeapp/core/constants/urls.dart';
import 'package:animeapp/core/error/exception.dart';
import 'package:animeapp/features/anime/data/datasources/anime_remote_datasource.dart';
import 'package:animeapp/features/anime/data/models/anime_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late AnimeRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = AnimeRemoteDataSourceImpl(httpClient: mockHttpClient);
    registerFallbackValue(Uri());
  });

  group("Get Animes by Title", () {
    const String tTitle = "boruto";
    List<AnimeModel> expectedResult = jsonDecode(fixture("get_animes_by_title.json"))["search"].map<AnimeModel>((map) => AnimeModel.fromJson(map)).toList();

    test("should perform a GET request", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response(
            fixture("get_animes_by_title.json"),
            200,
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          ));
      await dataSource.getAnimesByTitle(title: tTitle);
      verify(() => mockHttpClient.get(Uri.parse("${Urls.remoteEndpoint}/Search/$tTitle")));
    });

    test("should return List<Anime> when response's status code is 200", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response(
            fixture("get_animes_by_title.json"),
            200,
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          ));
      List<AnimeModel> result = await dataSource.getAnimesByTitle(title: tTitle);
      expect(listEquals(result, expectedResult), true);
    });

    test("should throw ServerException when response's status code is not 200", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response("", 404));
      expect(() => dataSource.getAnimesByTitle(title: tTitle), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group("Get Iframe Urls by Id", () {
    const String tId = "boruto-naruto-next-generations-episode-1";
    List<String> expectedResult = jsonDecode(fixture("get_iframe_urls_by_id.json"))["anime"][0]["servers"].map<String>((map) => map["iframe"].toString()).toList();

    test("should perform a GET request", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response(
            fixture("get_iframe_urls_by_id.json"),
            200,
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          ));
      await dataSource.getIframeUrlsById(id: tId);
      verify(() => mockHttpClient.get(Uri.parse("${Urls.remoteEndpoint}/AnimeEpisodeHandler/$tId")));
    });

    test("should return List<String> when response's status code is 200", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response(
            fixture("get_iframe_urls_by_id.json"),
            200,
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          ));
      List<String> result = await dataSource.getIframeUrlsById(id: tId);
      expect(listEquals(result, expectedResult), true);
    });

    test("should throw ServerException when response's status code is not 200", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response("", 404));
      expect(() => dataSource.getIframeUrlsById(id: tId), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group("Get Ongoing Animes", () {
    List<AnimeModel> expectedResult = jsonDecode(fixture("get_ongoing_animes.json"))["anime"].map<AnimeModel>((map) => AnimeModel.fromJson(map)).toList();

    test("should perform a GET request", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response(
            fixture("get_ongoing_animes.json"),
            200,
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          ));
      await dataSource.getOngoingAnimes();
      verify(() => mockHttpClient.get(Uri.parse("${Urls.remoteEndpoint}/OngoingSeries")));
    });

    test("should return List<Anime> when response's status code is 200", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response(
            fixture("get_ongoing_animes.json"),
            200,
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          ));
      List<AnimeModel> result = await dataSource.getOngoingAnimes();
      expect(listEquals(result, expectedResult), true);
    });

    test("should throw ServerException when response's status code is not 200", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response("", 404));
      expect(() => dataSource.getOngoingAnimes(), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group("Get Popular Animes", () {
    const int tPage = 1;
    List<AnimeModel> expectedResult = jsonDecode(fixture("get_popular_animes.json"))["popular"].map<AnimeModel>((map) => AnimeModel.fromJson(map)).toList();

    test("should perform a GET request", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response(
            fixture("get_popular_animes.json"),
            200,
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          ));
      await dataSource.getPopularAnimes(page: tPage);
      verify(() => mockHttpClient.get(Uri.parse("${Urls.remoteEndpoint}/Popular/$tPage")));
    });

    test("should return List<Anime> when response's status code is 200", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response(
            fixture("get_popular_animes.json"),
            200,
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          ));
      List<AnimeModel> result = await dataSource.getPopularAnimes(page: tPage);
      expect(listEquals(result, expectedResult), true);
    });

    test("should throw ServerException when response's status code is not 200", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response("", 404));
      expect(() => dataSource.getPopularAnimes(page: tPage), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group("Get Recently Added Animes", () {
    List<AnimeModel> expectedResult = jsonDecode(fixture("get_recently_added_animes.json"))["anime"].map<AnimeModel>((map) => AnimeModel.fromJson(map)).toList();

    test("should perform a GET request", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response(
            fixture("get_recently_added_animes.json"),
            200,
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          ));
      await dataSource.getRecentlyAddedAnimes();
      verify(() => mockHttpClient.get(Uri.parse("${Urls.remoteEndpoint}/RecentlyAddedSeries")));
    });

    test("should return List<Anime> when response's status code is 200", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response(
            fixture("get_recently_added_animes.json"),
            200,
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          ));
      List<AnimeModel> result = await dataSource.getRecentlyAddedAnimes();
      expect(listEquals(result, expectedResult), true);
    });

    test("should throw ServerException when response's status code is not 200", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response("", 404));
      expect(() => dataSource.getRecentlyAddedAnimes(), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group("Get Recently Released Episodes", () {
    const int tPage = 1;
    List<AnimeModel> expectedResult = jsonDecode(fixture("get_recently_released_episodes.json"))["anime"].map<AnimeModel>((map) => AnimeModel.fromJson(map)).toList();

    test("should perform a GET request", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response(
            fixture("get_recently_released_episodes.json"),
            200,
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          ));
      await dataSource.getRecentlyReleasedEpisodes(page: tPage);
      verify(() => mockHttpClient.get(Uri.parse("${Urls.remoteEndpoint}/RecentReleaseEpisodes/$tPage")));
    });

    test("should return List<Anime> when response's status code is 200", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response(
            fixture("get_recently_released_episodes.json"),
            200,
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          ));
      List<AnimeModel> result = await dataSource.getRecentlyReleasedEpisodes(page: tPage);
      expect(listEquals(result, expectedResult), true);
    });

    test("should throw ServerException when response's status code is not 200", () async {
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response("", 404));
      expect(() => dataSource.getRecentlyReleasedEpisodes(page: tPage), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
