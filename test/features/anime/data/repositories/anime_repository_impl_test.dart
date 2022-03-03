import 'package:animeapp/core/error/exception.dart';
import 'package:animeapp/core/error/failures.dart';
import 'package:animeapp/core/network/network_info.dart';
import 'package:animeapp/features/anime/data/datasources/anime_local_datasource.dart';
import 'package:animeapp/features/anime/data/datasources/anime_remote_datasource.dart';
import 'package:animeapp/features/anime/data/models/anime_model.dart';
import 'package:animeapp/features/anime/data/repositories/anime_repository_impl.dart';
import 'package:animeapp/features/anime/domain/entities/anime.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnimeRemoteDataSource extends Mock implements AnimeRemoteDataSource {}

class MockAnimeLocalDataSource extends Mock implements AnimeLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late AnimeRepositoryImpl animeRepositoryImpl;
  late MockAnimeRemoteDataSource mockAnimeRemoteDataSource;
  late MockAnimeLocalDataSource mockAnimeLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockAnimeRemoteDataSource = MockAnimeRemoteDataSource();
    mockAnimeLocalDataSource = MockAnimeLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    animeRepositoryImpl = AnimeRepositoryImpl(
      animeRemoteDataSource: mockAnimeRemoteDataSource,
      animeLocalDataSource: mockAnimeLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group("when device is online", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group("when device is offline", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group("Get Animes by Title", () {
    const String tTitle = "boruto";
    List<AnimeModel> tAnimeModels = [
      const AnimeModel(
        title: "Boruto: Naruto Next Generations",
        imageUrl: "https://gogocdn.net/cover/boruto-naruto-next-generations.png",
        synopsis: "Plot Summary: Naruto was a young shinobi with an incorrigible knack for mischief. He achieved his dream to become the greatest ninja in the village and his face sits atop the Hokage monument. But this is not his story... A new generation of ninja are ready to take the stage, led by Naruto's own son, Boruto!",
        genres: ["action", "adventure", "martial-arts", "shounen", "super-power"],
        status: "Ongoing",
        category: "Spring 2017 Anime",
        releasedYear: 2017,
        totalEpisodes: 237,
      )
    ];

    test("should check whether device is online or offline", () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockAnimeRemoteDataSource.getAnimesByTitle(title: any(named: "title"))).thenAnswer((_) async => []);
      when(() => mockAnimeLocalDataSource.cacheRecentlyAddedAnimes([])).thenAnswer((_) => Future.value());
      await animeRepositoryImpl.getAnimesByTitle(title: "abc");
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test("should return remote data when call to remote data source is successful", () async {
        when(() => mockAnimeRemoteDataSource.getAnimesByTitle(title: any(named: "title"))).thenAnswer((_) async => tAnimeModels);
        when(() => mockAnimeLocalDataSource.cacheRecentlyAddedAnimes(any())).thenAnswer((_) => Future.value());
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getAnimesByTitle(title: tTitle);
        verify(() => mockAnimeRemoteDataSource.getAnimesByTitle(title: tTitle));
        expect(
          listEquals(result.toOption().toNullable(), Right<Failure, List<Anime>>(tAnimeModels).toOption().toNullable()),
          true,
        );
        verifyZeroInteractions(mockAnimeLocalDataSource);
      });

      test("should return ServerFailure when call to remote data source is unsuccessful", () async {
        when(() => mockAnimeRemoteDataSource.getAnimesByTitle(title: any(named: "title"))).thenThrow(ServerException(statusCode: 404, statusMessage: "Not Found"));
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getAnimesByTitle(title: tTitle);
        verify(() => mockAnimeRemoteDataSource.getAnimesByTitle(title: tTitle));
        verifyZeroInteractions(mockAnimeLocalDataSource);
        expect(result, equals(Left(ServerFailure(message: "Not Found"))));
      });
    });

    runTestOffline(() {
      test("should return ServerFailure", () async {
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getAnimesByTitle(title: tTitle);
        expect(result, equals(Left(ServerFailure(message: "Not Found"))));
      });
    });
  });

  group("Get Ongoing Animes", () {
    List<AnimeModel> tAnimeModels = [
      const AnimeModel(
        title: "Boruto: Naruto Next Generations",
        imageUrl: "https://gogocdn.net/cover/boruto-naruto-next-generations.png",
        synopsis: "Plot Summary: Naruto was a young shinobi with an incorrigible knack for mischief. He achieved his dream to become the greatest ninja in the village and his face sits atop the Hokage monument. But this is not his story... A new generation of ninja are ready to take the stage, led by Naruto's own son, Boruto!",
        genres: ["action", "adventure", "martial-arts", "shounen", "super-power"],
        status: "Ongoing",
        category: "Spring 2017 Anime",
        releasedYear: 2017,
        totalEpisodes: 237,
      )
    ];

    test("should check whether device is online or offline", () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockAnimeRemoteDataSource.getOngoingAnimes()).thenAnswer((_) async => []);
      when(() => mockAnimeLocalDataSource.cacheOngoingAnimes([])).thenAnswer((_) => Future.value());
      await animeRepositoryImpl.getOngoingAnimes();
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test("should return remote data & cache when call to remote data source is successful", () async {
        when(() => mockAnimeRemoteDataSource.getOngoingAnimes()).thenAnswer((_) async => tAnimeModels);
        when(() => mockAnimeLocalDataSource.cacheOngoingAnimes(any())).thenAnswer((_) => Future.value());
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getOngoingAnimes();
        verify(() => mockAnimeRemoteDataSource.getOngoingAnimes());
        expect(
          listEquals(result.toOption().toNullable(), Right<Failure, List<Anime>>(tAnimeModels).toOption().toNullable()),
          true,
        );
        verify(() => mockAnimeLocalDataSource.cacheOngoingAnimes(tAnimeModels));
      });

      test("should return ServerFailure when call to remote data source is unsuccessful", () async {
        when(() => mockAnimeRemoteDataSource.getOngoingAnimes()).thenThrow(ServerException(statusCode: 404, statusMessage: "Not Found"));
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getOngoingAnimes();
        verify(() => mockAnimeRemoteDataSource.getOngoingAnimes());
        verifyZeroInteractions(mockAnimeLocalDataSource);
        expect(result, equals(Left(ServerFailure(message: "Not Found"))));
      });
    });

    runTestOffline(() {
      test("should return cache data when call to local data source is successful", () async {
        when(() => mockAnimeLocalDataSource.getOngoingAnimes()).thenAnswer((_) async => tAnimeModels);
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getOngoingAnimes();
        verify(() => mockAnimeLocalDataSource.getOngoingAnimes());
        expect(
          listEquals(result.toOption().toNullable(), Right<Failure, List<Anime>>(tAnimeModels).toOption().toNullable()),
          true,
        );
      });

      test("should return CacheFailure when call to local data source is unsuccessful", () async {
        when(() => mockAnimeLocalDataSource.getOngoingAnimes()).thenThrow(CacheException());
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getOngoingAnimes();
        verify(() => mockAnimeLocalDataSource.getOngoingAnimes());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group("Get Popular Animes", () {
    const int tPage1 = 1;
    const int tPage2 = 2;
    List<AnimeModel> tAnimeModels = [
      const AnimeModel(
        title: "Boruto: Naruto Next Generations",
        imageUrl: "https://gogocdn.net/cover/boruto-naruto-next-generations.png",
        synopsis: "Plot Summary: Naruto was a young shinobi with an incorrigible knack for mischief. He achieved his dream to become the greatest ninja in the village and his face sits atop the Hokage monument. But this is not his story... A new generation of ninja are ready to take the stage, led by Naruto's own son, Boruto!",
        genres: ["action", "adventure", "martial-arts", "shounen", "super-power"],
        status: "Ongoing",
        category: "Spring 2017 Anime",
        releasedYear: 2017,
        totalEpisodes: 237,
      )
    ];

    test("should check whether device is online or offline", () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockAnimeRemoteDataSource.getPopularAnimes(page: any(named: "page"))).thenAnswer((_) async => []);
      when(() => mockAnimeLocalDataSource.cachePopularAnimes([])).thenAnswer((_) => Future.value());
      await animeRepositoryImpl.getPopularAnimes(page: 1);
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test("should return remote data & cache first page when call to remote data source is successful", () async {
        when(() => mockAnimeRemoteDataSource.getPopularAnimes(page: any(named: "page"))).thenAnswer((_) async => tAnimeModels);
        when(() => mockAnimeLocalDataSource.cachePopularAnimes(any())).thenAnswer((_) => Future.value());
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getPopularAnimes(page: tPage1);
        verify(() => mockAnimeRemoteDataSource.getPopularAnimes(page: tPage1));
        expect(
          listEquals(result.toOption().toNullable(), Right<Failure, List<Anime>>(tAnimeModels).toOption().toNullable()),
          true,
        );
        verify(() => mockAnimeLocalDataSource.cachePopularAnimes(tAnimeModels));
      });

      test("should return remote data and not cache anything other than first page when call to remote data source is successful", () async {
        when(() => mockAnimeRemoteDataSource.getPopularAnimes(page: any(named: "page"))).thenAnswer((_) async => tAnimeModels);
        when(() => mockAnimeLocalDataSource.cachePopularAnimes(any())).thenAnswer((_) => Future.value());
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getPopularAnimes(page: tPage2);
        verify(() => mockAnimeRemoteDataSource.getPopularAnimes(page: tPage2));
        expect(
          listEquals(result.toOption().toNullable(), Right<Failure, List<Anime>>(tAnimeModels).toOption().toNullable()),
          true,
        );
        verifyNever(() => mockAnimeLocalDataSource.cachePopularAnimes(tAnimeModels));
      });

      test("should return ServerFailure when call to remote data source is unsuccessful", () async {
        when(() => mockAnimeRemoteDataSource.getPopularAnimes(page: any(named: "page"))).thenThrow(ServerException(statusCode: 404, statusMessage: "Not Found"));
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getPopularAnimes(page: tPage1);
        verify(() => mockAnimeRemoteDataSource.getPopularAnimes(page: tPage1));
        verifyZeroInteractions(mockAnimeLocalDataSource);
        expect(result, equals(Left(ServerFailure(message: "Not Found"))));
      });
    });

    runTestOffline(() {
      test("should return cache data when call to local data source is successful", () async {
        when(() => mockAnimeLocalDataSource.getPopularAnimes()).thenAnswer((_) async => tAnimeModels);
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getPopularAnimes(page: tPage1);
        verify(() => mockAnimeLocalDataSource.getPopularAnimes());
        expect(
          listEquals(result.toOption().toNullable(), Right<Failure, List<Anime>>(tAnimeModels).toOption().toNullable()),
          true,
        );
      });

      test("should return CacheFailure when call to local data source is unsuccessful", () async {
        when(() => mockAnimeLocalDataSource.getPopularAnimes()).thenThrow(CacheException());
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getPopularAnimes(page: tPage1);
        verify(() => mockAnimeLocalDataSource.getPopularAnimes());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group("Get Recently Added Animes", () {
    List<AnimeModel> tAnimeModels = [
      const AnimeModel(
        title: "Boruto: Naruto Next Generations",
        imageUrl: "https://gogocdn.net/cover/boruto-naruto-next-generations.png",
        synopsis: "Plot Summary: Naruto was a young shinobi with an incorrigible knack for mischief. He achieved his dream to become the greatest ninja in the village and his face sits atop the Hokage monument. But this is not his story... A new generation of ninja are ready to take the stage, led by Naruto's own son, Boruto!",
        genres: ["action", "adventure", "martial-arts", "shounen", "super-power"],
        status: "Ongoing",
        category: "Spring 2017 Anime",
        releasedYear: 2017,
        totalEpisodes: 237,
      )
    ];

    test("should check whether device is online or offline", () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockAnimeRemoteDataSource.getRecentlyAddedAnimes()).thenAnswer((_) async => []);
      when(() => mockAnimeLocalDataSource.cacheRecentlyAddedAnimes([])).thenAnswer((_) => Future.value());
      await animeRepositoryImpl.getRecentlyAddedAnimes();
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test("should return remote data & cache when call to remote data source is successful", () async {
        when(() => mockAnimeRemoteDataSource.getRecentlyAddedAnimes()).thenAnswer((_) async => tAnimeModels);
        when(() => mockAnimeLocalDataSource.cacheRecentlyAddedAnimes(any())).thenAnswer((_) => Future.value());
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getRecentlyAddedAnimes();
        verify(() => mockAnimeRemoteDataSource.getRecentlyAddedAnimes());
        expect(
          listEquals(result.toOption().toNullable(), Right<Failure, List<Anime>>(tAnimeModels).toOption().toNullable()),
          true,
        );
        verify(() => mockAnimeLocalDataSource.cacheRecentlyAddedAnimes(tAnimeModels));
      });

      test("should return ServerFailure when call to remote data source is unsuccessful", () async {
        when(() => mockAnimeRemoteDataSource.getRecentlyAddedAnimes()).thenThrow(ServerException(statusCode: 404, statusMessage: "Not Found"));
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getRecentlyAddedAnimes();
        verify(() => mockAnimeRemoteDataSource.getRecentlyAddedAnimes());
        verifyZeroInteractions(mockAnimeLocalDataSource);
        expect(result, equals(Left(ServerFailure(message: "Not Found"))));
      });
    });

    runTestOffline(() {
      test("should return cache data when call to local data source is successful", () async {
        when(() => mockAnimeLocalDataSource.getRecentlyAddedAnimes()).thenAnswer((_) async => tAnimeModels);
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getRecentlyAddedAnimes();
        verify(() => mockAnimeLocalDataSource.getRecentlyAddedAnimes());
        expect(
          listEquals(result.toOption().toNullable(), Right<Failure, List<Anime>>(tAnimeModels).toOption().toNullable()),
          true,
        );
      });

      test("should return CacheFailure when call to local data source is unsuccessful", () async {
        when(() => mockAnimeLocalDataSource.getRecentlyAddedAnimes()).thenThrow(CacheException());
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getRecentlyAddedAnimes();
        verify(() => mockAnimeLocalDataSource.getRecentlyAddedAnimes());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group("Get Recently Released Episodes", () {
    const int tPage1 = 1;
    const int tPage2 = 2;
    List<AnimeModel> tAnimeModels = [
      const AnimeModel(
        title: "Boruto: Naruto Next Generations",
        imageUrl: "https://gogocdn.net/cover/boruto-naruto-next-generations.png",
        synopsis: "Plot Summary: Naruto was a young shinobi with an incorrigible knack for mischief. He achieved his dream to become the greatest ninja in the village and his face sits atop the Hokage monument. But this is not his story... A new generation of ninja are ready to take the stage, led by Naruto's own son, Boruto!",
        genres: ["action", "adventure", "martial-arts", "shounen", "super-power"],
        status: "Ongoing",
        category: "Spring 2017 Anime",
        releasedYear: 2017,
        totalEpisodes: 237,
      )
    ];

    test("should check whether device is online or offline", () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockAnimeRemoteDataSource.getRecentlyReleasedEpisodes(page: any(named: "page"))).thenAnswer((_) async => []);
      when(() => mockAnimeLocalDataSource.cacheRecentlyReleasedEpisodes([])).thenAnswer((_) => Future.value());
      await animeRepositoryImpl.getRecentlyReleasedEpisodes(page: 1);
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test("should return remote data & cache first page when call to remote data source is successful", () async {
        when(() => mockAnimeRemoteDataSource.getRecentlyReleasedEpisodes(page: any(named: "page"))).thenAnswer((_) async => tAnimeModels);
        when(() => mockAnimeLocalDataSource.cacheRecentlyReleasedEpisodes(any())).thenAnswer((_) => Future.value());
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getRecentlyReleasedEpisodes(page: tPage1);
        verify(() => mockAnimeRemoteDataSource.getRecentlyReleasedEpisodes(page: tPage1));
        expect(
          listEquals(result.toOption().toNullable(), Right<Failure, List<Anime>>(tAnimeModels).toOption().toNullable()),
          true,
        );
        verify(() => mockAnimeLocalDataSource.cacheRecentlyReleasedEpisodes(tAnimeModels));
      });

      test("should return remote data and not cache anything other than first page when call to remote data source is successful", () async {
        when(() => mockAnimeRemoteDataSource.getRecentlyReleasedEpisodes(page: any(named: "page"))).thenAnswer((_) async => tAnimeModels);
        when(() => mockAnimeLocalDataSource.cacheRecentlyReleasedEpisodes(any())).thenAnswer((_) => Future.value());
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getRecentlyReleasedEpisodes(page: tPage2);
        verify(() => mockAnimeRemoteDataSource.getRecentlyReleasedEpisodes(page: tPage2));
        expect(
          listEquals(result.toOption().toNullable(), Right<Failure, List<Anime>>(tAnimeModels).toOption().toNullable()),
          true,
        );
        verifyNever(() => mockAnimeLocalDataSource.cacheRecentlyReleasedEpisodes(tAnimeModels));
      });

      test("should return ServerFailure when call to remote data source is unsuccessful", () async {
        when(() => mockAnimeRemoteDataSource.getRecentlyReleasedEpisodes(page: any(named: "page"))).thenThrow(ServerException(statusCode: 404, statusMessage: "Not Found"));
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getRecentlyReleasedEpisodes(page: tPage1);
        verify(() => mockAnimeRemoteDataSource.getRecentlyReleasedEpisodes(page: tPage1));
        verifyZeroInteractions(mockAnimeLocalDataSource);
        expect(result, equals(Left(ServerFailure(message: "Not Found"))));
      });
    });

    runTestOffline(() {
      test("should return cache data when call to local data source is successful", () async {
        when(() => mockAnimeLocalDataSource.getRecentlyReleasedEpisodes()).thenAnswer((_) async => tAnimeModels);
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getRecentlyReleasedEpisodes(page: tPage1);
        verify(() => mockAnimeLocalDataSource.getRecentlyReleasedEpisodes());
        expect(
          listEquals(result.toOption().toNullable(), Right<Failure, List<Anime>>(tAnimeModels).toOption().toNullable()),
          true,
        );
      });

      test("should return CacheFailure when call to local data source is unsuccessful", () async {
        when(() => mockAnimeLocalDataSource.getRecentlyReleasedEpisodes()).thenThrow(CacheException());
        Either<Failure, List<Anime>> result = await animeRepositoryImpl.getRecentlyReleasedEpisodes(page: tPage1);
        verify(() => mockAnimeLocalDataSource.getRecentlyReleasedEpisodes());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
