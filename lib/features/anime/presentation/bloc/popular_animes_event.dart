part of 'popular_animes_bloc.dart';

abstract class PopularAnimesEvent extends Equatable {
  const PopularAnimesEvent();

  @override
  List<Object> get props => [];
}

class GetPopularAnimesByPage extends PopularAnimesEvent {
  final int page;
  const GetPopularAnimesByPage({required this.page});
}
