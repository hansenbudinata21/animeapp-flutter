part of 'search_animes_bloc.dart';

abstract class SearchAnimesState extends Equatable {
  const SearchAnimesState();

  @override
  List<Object> get props => [];
}

class SearchAnimesInitial extends SearchAnimesState {}

class SearchAnimesLoading extends SearchAnimesState {}

class SearchAnimesEmpty extends SearchAnimesState {}

class SearchAnimesLoaded extends SearchAnimesState {
  final List<Anime> searchAnimes;
  const SearchAnimesLoaded({required this.searchAnimes});
}

class SearchAnimesError extends SearchAnimesState {
  final String errorMessage;
  const SearchAnimesError({required this.errorMessage});
}
