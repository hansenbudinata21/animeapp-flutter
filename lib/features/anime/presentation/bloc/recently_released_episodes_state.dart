part of 'recently_released_episodes_bloc.dart';

abstract class RecentlyReleasedEpisodesState extends Equatable {
  const RecentlyReleasedEpisodesState();

  @override
  List<Object> get props => [];
}

class RecentlyReleasedEpisodesInitial extends RecentlyReleasedEpisodesState {}

class RecentlyReleasedEpisodesLoading extends RecentlyReleasedEpisodesState {}

class RecentlyReleasedEpisodesLoaded extends RecentlyReleasedEpisodesState {
  final List<Anime> recentlyReleasedEpisodes;
  const RecentlyReleasedEpisodesLoaded({required this.recentlyReleasedEpisodes});
}

class RecentlyReleasedEpisodesError extends RecentlyReleasedEpisodesState {
  final String errorMessage;
  const RecentlyReleasedEpisodesError({required this.errorMessage});
}
