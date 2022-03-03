import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/anime.dart';
import '../repositories/anime_repository.dart';

class GetAnimesByTitle implements UseCase<List<Anime>, Params> {
  final AnimeRepository animeRepository;
  const GetAnimesByTitle(this.animeRepository);

  @override
  Future<Either<Failure, List<Anime>>> call(Params params) async {
    return await animeRepository.getAnimesByTitle(title: params.title);
  }
}

class Params extends Equatable {
  final String title;
  const Params({required this.title});

  @override
  List<Object?> get props => [title];
}
