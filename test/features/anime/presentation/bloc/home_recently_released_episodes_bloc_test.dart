import 'package:animeapp/core/error/failures.dart';
import 'package:animeapp/features/anime/domain/entities/anime.dart';
import 'package:animeapp/features/anime/domain/usecases/get_recently_released_episodes.dart';
import 'package:animeapp/features/anime/presentation/bloc/recently_released_episodes_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetRecentlyReleasedEpisodes extends Mock implements GetRecentlyReleasedEpisodes {}

void main() {
  late RecentlyReleasedEpisodesBloc bloc;
  late MockGetRecentlyReleasedEpisodes mockGetRecentlyReleasedEpisodes;

  setUp(() {
    mockGetRecentlyReleasedEpisodes = MockGetRecentlyReleasedEpisodes();
    bloc = RecentlyReleasedEpisodesBloc(getRecentlyReleasedEpisodes: mockGetRecentlyReleasedEpisodes);
    registerFallbackValue(const Params(page: 1));
  });

  test("initial state should be HomeRecentlyReleasedEpisodesInitial", () {
    expect(bloc.state, equals(RecentlyReleasedEpisodesInitial()));
  });

  group("in case of GetHomeRecentlyReleasedEpisodes event", () {
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

    test("should get data from get_recently_released_episodes usecase with params from the event", () async {
      when(() => mockGetRecentlyReleasedEpisodes(any())).thenAnswer((_) async => Right(tAnimes));
      final GetFirstTwentyRecentlyReleasedEpisodes event = GetFirstTwentyRecentlyReleasedEpisodes();
      bloc.add(event);
      await untilCalled(() => mockGetRecentlyReleasedEpisodes(any()));
      verify(() => mockGetRecentlyReleasedEpisodes(Params(page: event.page)));
    });

    test("should emit [HomeRecentlyReleasedEpisodesLoading, HomeRecentlyReleasedEpisodesLoaded] when data is gotten successfully", () async {
      when(() => mockGetRecentlyReleasedEpisodes(any())).thenAnswer((_) async => Right(tAnimes));
      final List<RecentlyReleasedEpisodesState> expectedResults = [
        RecentlyReleasedEpisodesLoading(),
        RecentlyReleasedEpisodesLoaded(recentlyReleasedEpisodes: tAnimes),
      ];
      expectLater(bloc.stream, emitsInOrder(expectedResults));
      bloc.add(GetFirstTwentyRecentlyReleasedEpisodes());
    });

    test(
      "should emit [HomeRecentlyReleasedEpisodesLoading, HomeRecentlyReleasedEpisodesError] when getting data fails",
      () async {
        when(() => mockGetRecentlyReleasedEpisodes(any())).thenAnswer((_) async => Left(ServerFailure(message: tErrorMessage)));
        final List<RecentlyReleasedEpisodesState> expectedResults = [
          RecentlyReleasedEpisodesLoading(),
          const RecentlyReleasedEpisodesError(errorMessage: tErrorMessage),
        ];
        expectLater(bloc.stream, emitsInOrder(expectedResults));
        bloc.add(GetFirstTwentyRecentlyReleasedEpisodes());
      },
    );
  });
}
