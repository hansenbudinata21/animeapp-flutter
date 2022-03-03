part of 'popular_animes_bloc.dart';

abstract class PopularAnimesState extends Equatable {
  const PopularAnimesState();

  @override
  List<Object> get props => [];
}

class PopularAnimesInitial extends PopularAnimesState {}

class PopularAnimesLoading extends PopularAnimesState {}

class PopularAnimesLoaded extends PopularAnimesState {
  final int page;
  final List<Anime> popularAnimes;
  const PopularAnimesLoaded({required this.page, required this.popularAnimes});
}

class PopularAnimesError extends PopularAnimesState {
  final String errorMessage;
  const PopularAnimesError({required this.errorMessage});
}
