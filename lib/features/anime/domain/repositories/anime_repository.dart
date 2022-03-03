import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/anime.dart';

abstract class AnimeRepository {
  Future<Either<Failure, List<Anime>>> getAnimesByTitle({required String title});
  Future<Either<Failure, List<String>>> getIframeUrlsById({required String id});
  Future<Either<Failure, List<Anime>>> getOngoingAnimes();
  Future<Either<Failure, List<Anime>>> getPopularAnimes({required int page});
  Future<Either<Failure, List<Anime>>> getRecentlyAddedAnimes();
  Future<Either<Failure, List<Anime>>> getRecentlyReleasedEpisodes({required int page});
}
