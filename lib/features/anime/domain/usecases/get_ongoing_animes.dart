import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/anime.dart';
import '../repositories/anime_repository.dart';

class GetOngoingAnimes implements UseCase<List<Anime>, NoParams> {
  final AnimeRepository animeRepository;
  const GetOngoingAnimes(this.animeRepository);

  @override
  Future<Either<Failure, List<Anime>>> call(_) async {
    return await animeRepository.getOngoingAnimes();
  }
}
