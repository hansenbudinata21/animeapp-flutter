import 'package:animeapp/core/error/failures.dart';
import 'package:animeapp/features/anime/domain/entities/anime.dart';
import 'package:animeapp/features/anime/domain/repositories/anime_repository.dart';
import 'package:animeapp/features/anime/domain/usecases/get_animes_by_title.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnimeRepository extends Mock implements AnimeRepository {}

void main() {
  late GetAnimesByTitle usecase;
  late MockAnimeRepository mockAnimeRepository;

  setUp(() {
    mockAnimeRepository = MockAnimeRepository();
    usecase = GetAnimesByTitle(mockAnimeRepository);
  });

  const String tTitle = "Boruto";
  List<Anime> tAnimes = [
    const Anime(
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

  test("Get Recently Released Episodes UseCase should get List<Anime> from AnimeRepository", () async {
    when(() => mockAnimeRepository.getAnimesByTitle(title: any(named: "title"))).thenAnswer((_) async => Right(tAnimes));
    Either<Failure, List<Anime>> result = await usecase(const Params(title: tTitle));
    expect(result, equals(Right(tAnimes)));
    verify(() => mockAnimeRepository.getAnimesByTitle(title: tTitle));
    verifyNoMoreInteractions(mockAnimeRepository);
  });
}
