import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/anime_repository.dart';

class GetIframeUrlsById implements UseCase<List<String>, Params> {
  final AnimeRepository animeRepository;
  const GetIframeUrlsById(this.animeRepository);

  @override
  Future<Either<Failure, List<String>>> call(Params params) async {
    return await animeRepository.getIframeUrlsById(id: params.id);
  }
}

class Params extends Equatable {
  final String id;
  const Params({required this.id});

  @override
  List<Object?> get props => [id];
}
