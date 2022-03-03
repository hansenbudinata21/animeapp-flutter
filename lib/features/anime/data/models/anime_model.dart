import '../../domain/entities/anime.dart';

class AnimeModel extends Anime {
  const AnimeModel({
    required String title,
    required String imageUrl,
    required String synopsis,
    required List<String> genres,
    String? category,
    required String status,
    int? releasedYear,
    required int totalEpisodes,
    String? lastEpisodeId,
    List<String> episodesId = const [],
  }) : super(
          title: title,
          imageUrl: imageUrl,
          synopsis: synopsis,
          genres: genres,
          status: status,
          category: category,
          releasedYear: releasedYear,
          totalEpisodes: totalEpisodes,
          lastEpisodeId: lastEpisodeId,
          episodesId: episodesId,
        );

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      title: json["title"],
      imageUrl: json["img"],
      synopsis: json["synopsis"],
      genres: json["genres"].map<String>((json) => json.toString()).toList(),
      category: json["category"],
      status: json["status"],
      releasedYear: json["released"],
      totalEpisodes: (json["totalEpisodes"] ?? 1) - 1,
      lastEpisodeId: json["id"],
      episodesId: json["episodes"] == null ? [] : json["episodes"].map<String>((map) => map["id"].toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "title": title,
      "img": imageUrl,
      "synopsis": synopsis,
      "genres": genres,
      "category": category,
      "status": status,
      "released": releasedYear,
      "totalEpisodes": totalEpisodes + 1,
    };
    if (lastEpisodeId != null) json["id"] = lastEpisodeId;
    if (episodesId.isNotEmpty) json["episodes"] = episodesId.map((String episodeId) => {"id": episodeId}).toList();

    return json;
  }
}
