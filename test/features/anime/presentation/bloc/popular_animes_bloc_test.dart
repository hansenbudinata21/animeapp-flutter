import 'package:animeapp/core/error/failures.dart';
import 'package:animeapp/features/anime/domain/entities/anime.dart';
import 'package:animeapp/features/anime/domain/usecases/get_popular_animes.dart';
import 'package:animeapp/features/anime/presentation/bloc/popular_animes_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPopularAnimes extends Mock implements GetPopularAnimes {}

void main() {
  late PopularAnimesBloc bloc;
  late MockGetPopularAnimes mockGetPopularAnimes;

  setUp(() {
    mockGetPopularAnimes = MockGetPopularAnimes();
    bloc = PopularAnimesBloc(getPopularAnimes: mockGetPopularAnimes);
    registerFallbackValue(const Params(page: 1));
  });

  test("initial state should be PopularAnimesInitial", () {
    expect(bloc.state, equals(PopularAnimesInitial()));
  });

  group("in case of GetPopularAnimes event", () {
    const int tPage = 1;
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

    test("should get data from get_popular_animes usecase with params from the event", () async {
      when(() => mockGetPopularAnimes(any())).thenAnswer((_) async => Right(tAnimes));
      const GetPopularAnimesByPage event = GetPopularAnimesByPage(page: tPage);
      bloc.add(event);
      await untilCalled(() => mockGetPopularAnimes(any()));
      verify(() => mockGetPopularAnimes(Params(page: event.page)));
    });

    test("should emit [PopularAnimesLoading, PopularAnimesLoaded] when data is gotten successfully", () async {
      when(() => mockGetPopularAnimes(any())).thenAnswer((_) async => Right(tAnimes));
      final List<PopularAnimesState> expectedResults = [
        PopularAnimesLoading(),
        PopularAnimesLoaded(page: tPage, popularAnimes: tAnimes),
      ];
      expectLater(bloc.stream, emitsInOrder(expectedResults));
      bloc.add(const GetPopularAnimesByPage(page: tPage));
    });

    test(
      "should emit [PopularAnimesLoading, PopularAnimesError] when getting data fails",
      () async {
        when(() => mockGetPopularAnimes(any())).thenAnswer((_) async => Left(ServerFailure(message: tErrorMessage)));
        final List<PopularAnimesState> expectedResults = [
          PopularAnimesLoading(),
          const PopularAnimesError(errorMessage: tErrorMessage),
        ];
        expectLater(bloc.stream, emitsInOrder(expectedResults));
        bloc.add(const GetPopularAnimesByPage(page: tPage));
      },
    );
  });
}
