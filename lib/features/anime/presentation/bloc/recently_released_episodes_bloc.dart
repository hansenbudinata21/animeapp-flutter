import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/anime.dart';
import '../../domain/usecases/get_recently_released_episodes.dart';

part 'recently_released_episodes_event.dart';
part 'recently_released_episodes_state.dart';

class RecentlyReleasedEpisodesBloc extends Bloc<RecentlyReleasedEpisodesEvent, RecentlyReleasedEpisodesState> {
  GetRecentlyReleasedEpisodes getRecentlyReleasedEpisodes;

  RecentlyReleasedEpisodesBloc({required this.getRecentlyReleasedEpisodes}) : super(RecentlyReleasedEpisodesInitial()) {
    on<GetFirstTwentyRecentlyReleasedEpisodes>((event, emit) async {
      emit(RecentlyReleasedEpisodesLoading());
      final Either<Failure, List<Anime>> result = await getRecentlyReleasedEpisodes(Params(page: event.page));
      emit(result.fold(
        (Failure failure) => RecentlyReleasedEpisodesError(errorMessage: failure.failureMessage),
        (List<Anime> animes) => RecentlyReleasedEpisodesLoaded(recentlyReleasedEpisodes: animes),
      ));
    });
  }
}
