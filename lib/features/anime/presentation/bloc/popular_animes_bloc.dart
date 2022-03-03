import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/anime.dart';
import '../../domain/usecases/get_popular_animes.dart';

part 'popular_animes_event.dart';
part 'popular_animes_state.dart';

class PopularAnimesBloc extends Bloc<PopularAnimesEvent, PopularAnimesState> {
  GetPopularAnimes getPopularAnimes;

  PopularAnimesBloc({required this.getPopularAnimes}) : super(PopularAnimesInitial()) {
    on<GetPopularAnimesByPage>((event, emit) async {
      emit(PopularAnimesLoading());
      final Either<Failure, List<Anime>> result = await getPopularAnimes(Params(page: event.page));
      emit(result.fold(
        (Failure failure) => PopularAnimesError(errorMessage: failure.failureMessage),
        (List<Anime> animes) => PopularAnimesLoaded(page: event.page, popularAnimes: animes),
      ));
    });
  }
}
