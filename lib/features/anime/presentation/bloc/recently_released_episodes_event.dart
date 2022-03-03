part of 'recently_released_episodes_bloc.dart';

abstract class RecentlyReleasedEpisodesEvent extends Equatable {
  const RecentlyReleasedEpisodesEvent();

  @override
  List<Object> get props => [];
}

class GetFirstTwentyRecentlyReleasedEpisodes extends RecentlyReleasedEpisodesEvent {
  final int page = 1;
}
