part of 'search_animes_bloc.dart';

abstract class SearchAnimesEvent extends Equatable {
  const SearchAnimesEvent();

  @override
  List<Object> get props => [];
}

class GetSearchAnimeByTitle extends SearchAnimesEvent {
  final String title;
  const GetSearchAnimeByTitle({required this.title});
}
