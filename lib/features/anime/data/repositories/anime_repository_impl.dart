import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/anime.dart';
import '../../domain/repositories/anime_repository.dart';
import '../datasources/anime_local_datasource.dart';
import '../datasources/anime_remote_datasource.dart';
import '../models/anime_model.dart';

class AnimeRepositoryImpl implements AnimeRepository {
  AnimeRemoteDataSource animeRemoteDataSource;
  AnimeLocalDataSource animeLocalDataSource;
  NetworkInfo networkInfo;

  AnimeRepositoryImpl({
    required this.animeRemoteDataSource,
    required this.animeLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Anime>>> getAnimesByTitle({required String title}) async {
    if (await networkInfo.isConnected) {
      try {
        List<AnimeModel> result = await animeRemoteDataSource.getAnimesByTitle(title: title);
        return Right(result);
      } on ServerException catch (se) {
        return Left(ServerFailure(message: se.statusMessage));
      }
    } else {
      return Left(ServerFailure(message: "Not Connected To Server"));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getIframeUrlsById({required String id}) async {
    if (await networkInfo.isConnected) {
      try {
        List<String> result = await animeRemoteDataSource.getIframeUrlsById(id: id);
        return Right(result);
      } on ServerException catch (se) {
        return Left(ServerFailure(message: se.statusMessage));
      }
    } else {
      return Left(ServerFailure(message: "Not Connected To Server"));
    }
  }

  @override
  Future<Either<Failure, List<Anime>>> getOngoingAnimes() async {
    if (await networkInfo.isConnected) {
      try {
        List<AnimeModel> result = await animeRemoteDataSource.getOngoingAnimes();
        animeLocalDataSource.cacheOngoingAnimes(result);
        return Right(result);
      } on ServerException catch (se) {
        return Left(ServerFailure(message: se.statusMessage));
      }
    } else {
      try {
        List<AnimeModel> result = await animeLocalDataSource.getOngoingAnimes();
        return Right(result);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Anime>>> getPopularAnimes({required int page}) async {
    if (await networkInfo.isConnected) {
      try {
        List<AnimeModel> result = await animeRemoteDataSource.getPopularAnimes(page: page);
        if (page == 1) animeLocalDataSource.cachePopularAnimes(result);
        return Right(result);
      } on ServerException catch (se) {
        return Left(ServerFailure(message: se.statusMessage));
      }
    } else {
      try {
        List<AnimeModel> result = await animeLocalDataSource.getPopularAnimes();
        return Right(result);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Anime>>> getRecentlyAddedAnimes() async {
    if (await networkInfo.isConnected) {
      try {
        List<AnimeModel> result = await animeRemoteDataSource.getRecentlyAddedAnimes();
        animeLocalDataSource.cacheRecentlyAddedAnimes(result);
        return Right(result);
      } on ServerException catch (se) {
        return Left(ServerFailure(message: se.statusMessage));
      }
    } else {
      try {
        List<AnimeModel> result = await animeLocalDataSource.getRecentlyAddedAnimes();
        return Right(result);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Anime>>> getRecentlyReleasedEpisodes({required int page}) async {
    if (await networkInfo.isConnected) {
      try {
        List<AnimeModel> result = await animeRemoteDataSource.getRecentlyReleasedEpisodes(page: page);
        if (page == 1) animeLocalDataSource.cacheRecentlyReleasedEpisodes(result);
        return Right(result);
      } on ServerException catch (se) {
        return Left(ServerFailure(message: se.statusMessage));
      }
    } else {
      try {
        List<AnimeModel> result = await animeLocalDataSource.getRecentlyReleasedEpisodes();
        return Right(result);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
