import 'package:animeapp/core/error/failures.dart';
import 'package:animeapp/features/anime/domain/entities/anime.dart';
import 'package:animeapp/features/anime/domain/usecases/get_animes_by_title.dart';
import 'package:animeapp/features/anime/presentation/bloc/search_animes_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAnimesByTitle extends Mock implements GetAnimesByTitle {}

void main() {
  late SearchAnimesBloc bloc;
  late MockGetAnimesByTitle mockGetAnimesByTitle;

  setUp(() {
    mockGetAnimesByTitle = MockGetAnimesByTitle();
    bloc = SearchAnimesBloc(getAnimesByTitle: mockGetAnimesByTitle);
    registerFallbackValue(const Params(title: "Boruto"));
  });

  test("initial state should be SearchAnimesInitial", () {
    expect(bloc.state, equals(SearchAnimesInitial()));
  });

  group("in case of GetSearchAnimeByTitle event", () {
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
    const String tErrorMessage = "Not Found";

    test("should get data from get_animes_by_title usecase with params from the event", () async {
      when(() => mockGetAnimesByTitle(any())).thenAnswer((_) async => Right(tAnimes));
      const GetSearchAnimeByTitle event = GetSearchAnimeByTitle(title: tTitle);
      bloc.add(event);
      await untilCalled(() => mockGetAnimesByTitle(any()));
      verify(() => mockGetAnimesByTitle(Params(title: event.title)));
    });

    test("should emit [SearchAnimesLoading, SearchAnimesLoaded] when data is gotten successfully", () async {
      when(() => mockGetAnimesByTitle(any())).thenAnswer((_) async => Right(tAnimes));
      final List<SearchAnimesState> expectedResults = [
        SearchAnimesLoading(),
        SearchAnimesLoaded(searchAnimes: tAnimes),
      ];
      expectLater(bloc.stream, emitsInOrder(expectedResults));
      bloc.add(const GetSearchAnimeByTitle(title: tTitle));
    });

    test("should emit [SearchAnimesLoading, SearchAnimesLoaded] when data is gotten successfully, but empty", () async {
      when(() => mockGetAnimesByTitle(any())).thenAnswer((_) async => const Right([]));
      final List<SearchAnimesState> expectedResults = [
        SearchAnimesLoading(),
        SearchAnimesEmpty(),
      ];
      expectLater(bloc.stream, emitsInOrder(expectedResults));
      bloc.add(const GetSearchAnimeByTitle(title: tTitle));
    });

    test(
      "should emit [HomePopularAnimesLoading, HomePopularAnimesError] when getting data fails",
      () async {
        when(() => mockGetAnimesByTitle(any())).thenAnswer((_) async => Left(ServerFailure(message: tErrorMessage)));
        final List<SearchAnimesState> expectedResults = [
          SearchAnimesLoading(),
          const SearchAnimesError(errorMessage: tErrorMessage),
        ];
        expectLater(bloc.stream, emitsInOrder(expectedResults));
        bloc.add(const GetSearchAnimeByTitle(title: tTitle));
      },
    );
  });
}
