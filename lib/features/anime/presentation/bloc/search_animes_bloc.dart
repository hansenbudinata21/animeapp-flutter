import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/anime.dart';
import '../../domain/usecases/get_animes_by_title.dart';

part 'search_animes_event.dart';
part 'search_animes_state.dart';

class SearchAnimesBloc extends Bloc<SearchAnimesEvent, SearchAnimesState> {
  GetAnimesByTitle getAnimesByTitle;

  SearchAnimesBloc({required this.getAnimesByTitle}) : super(SearchAnimesInitial()) {
    on<GetSearchAnimeByTitle>(
      (event, emit) async {
        if (event.title.isEmpty) {
          emit(SearchAnimesInitial());
          return;
        }

        emit(SearchAnimesLoading());
        final Either<Failure, List<Anime>> result = await getAnimesByTitle(Params(title: event.title));
        emit(result.fold(
          (Failure failure) => SearchAnimesError(errorMessage: failure.failureMessage),
          (List<Anime> animes) {
            if (animes.isEmpty) return SearchAnimesEmpty();
            return SearchAnimesLoaded(searchAnimes: animes);
          },
        ));
      },
      transformer: (events, mapper) {
        return events.debounceTime(const Duration(milliseconds: 300)).switchMap(mapper);
      },
    );
  }
}
