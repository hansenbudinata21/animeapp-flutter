import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/anime.dart';
import '../repositories/anime_repository.dart';

class GetRecentlyReleasedEpisodes implements UseCase<List<Anime>, Params> {
  final AnimeRepository animeRepository;
  const GetRecentlyReleasedEpisodes(this.animeRepository);

  @override
  Future<Either<Failure, List<Anime>>> call(Params params) async {
    return await animeRepository.getRecentlyReleasedEpisodes(page: params.page);
  }
}

class Params extends Equatable {
  final int page;
  const Params({required this.page});

  @override
  List<Object?> get props => [page];
}
