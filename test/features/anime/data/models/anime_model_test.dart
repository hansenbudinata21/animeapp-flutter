import 'dart:convert';

import 'package:animeapp/features/anime/data/models/anime_model.dart';
import 'package:animeapp/features/anime/domain/entities/anime.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  AnimeModel tAnimeModel = const AnimeModel(
    title: "Boruto: Naruto Next Generations",
    imageUrl: "https://gogocdn.net/cover/boruto-naruto-next-generations.png",
    synopsis: "Plot Summary: Naruto was a young shinobi with an incorrigible knack for mischief. He achieved his dream to become the greatest ninja in the village and his face sits atop the Hokage monument. But this is not his story... A new generation of ninja are ready to take the stage, led by Naruto's own son, Boruto!",
    genres: ["action", "adventure", "martial-arts", "shounen", "super-power"],
    status: "Ongoing",
    category: "Spring 2017 Anime",
    releasedYear: 2017,
    totalEpisodes: 237,
  );

  group("Anime Model", () {
    test("should be a sub class of Anime Entity", () {
      expect(tAnimeModel, isA<Anime>());
    });

    test("fromJson() should return a valid model given the JSON file", () {
      Map<String, dynamic> jsonMap = jsonDecode(fixture("anime_1.json"));
      Map<String, dynamic> jsonMap2 = jsonDecode(fixture("anime_2.json"));
      AnimeModel result = AnimeModel.fromJson(jsonMap);
      AnimeModel result2 = AnimeModel.fromJson(jsonMap2);
      expect(result, equals(tAnimeModel));
      expect(result2, equals(tAnimeModel));
    });

    test("toJson() should return a json map containing proper data", () {
      Map<String, dynamic> result = tAnimeModel.toJson();
      Map<String, dynamic> expectedResult = {
        "title": "Boruto: Naruto Next Generations",
        "img": "https://gogocdn.net/cover/boruto-naruto-next-generations.png",
        "synopsis": "Plot Summary: Naruto was a young shinobi with an incorrigible knack for mischief. He achieved his dream to become the greatest ninja in the village and his face sits atop the Hokage monument. But this is not his story... A new generation of ninja are ready to take the stage, led by Naruto's own son, Boruto!",
        "genres": ["action", "adventure", "martial-arts", "shounen", "super-power"],
        "status": "Ongoing",
        "category": "Spring 2017 Anime",
        "totalEpisodes": 238,
        "released": 2017,
      };

      expect(result, expectedResult);
    });
  });
}
