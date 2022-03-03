import 'package:animeapp/core/error/failures.dart';
import 'package:animeapp/features/anime/domain/repositories/anime_repository.dart';
import 'package:animeapp/features/anime/domain/usecases/get_iframe_urls_by_id.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnimeRepository extends Mock implements AnimeRepository {}

void main() {
  late GetIframeUrlsById usecase;
  late MockAnimeRepository mockAnimeRepository;

  setUp(() {
    mockAnimeRepository = MockAnimeRepository();
    usecase = GetIframeUrlsById(mockAnimeRepository);
  });

  const String tId = "boruto-naruto-next-generations-episode-1";
  List<String> tUrls = const [
    "gogoplay.io/embedplus?id=OTc2MzI=&token=iXsb4Z-7SsQRXRUbhEGn9w&expires=1645955161",
    "https://sbplay2.com/e/nb7suf37mhl7",
  ];

  test("Get Iframe Urls By Id UseCase should get List<String> from AnimeRepository", () async {
    when(() => mockAnimeRepository.getIframeUrlsById(id: any(named: "id"))).thenAnswer((_) async => Right(tUrls));
    Either<Failure, List<String>> result = await usecase(const Params(id: tId));
    expect(result, equals(Right(tUrls)));
    verify(() => mockAnimeRepository.getIframeUrlsById(id: tId));
    verifyNoMoreInteractions(mockAnimeRepository);
  });
}
