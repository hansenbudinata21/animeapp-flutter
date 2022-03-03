import 'package:equatable/equatable.dart';

class Anime extends Equatable {
  final String title;
  final String imageUrl;
  final String synopsis;
  final List<String> genres;
  final String? category;
  final int? releasedYear;
  final String status;
  final int totalEpisodes;
  final String? lastEpisodeId;
  final List<String> episodesId;

  const Anime({
    required this.title,
    required this.imageUrl,
    required this.synopsis,
    required this.genres,
    this.category,
    this.releasedYear,
    required this.status,
    required this.totalEpisodes,
    this.lastEpisodeId,
    this.episodesId = const [],
  });

  @override
  List<Object?> get props => [title];

  String get synopsisTrim => synopsis.split("Plot Summary: ")[1];
  String get categoryTrim => category?.split(" ")[0] ?? "-";
  String get lastEpisode => lastEpisodeId == null ? (episodesId.length - 1).toString() : lastEpisodeId!.split("-").last;
}
