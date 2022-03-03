import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/anime/data/datasources/anime_local_datasource.dart';
import 'features/anime/data/datasources/anime_remote_datasource.dart';
import 'features/anime/data/repositories/anime_repository_impl.dart';
import 'features/anime/domain/repositories/anime_repository.dart';
import 'features/anime/domain/usecases/get_animes_by_title.dart';
import 'features/anime/domain/usecases/get_iframe_urls_by_id.dart';
import 'features/anime/domain/usecases/get_ongoing_animes.dart';
import 'features/anime/domain/usecases/get_popular_animes.dart';
import 'features/anime/domain/usecases/get_recently_added_animes.dart';
import 'features/anime/domain/usecases/get_recently_released_episodes.dart';
import 'features/anime/presentation/bloc/recently_released_episodes_bloc.dart';
import 'features/anime/presentation/bloc/iframe_urls_bloc.dart';
import 'features/anime/presentation/bloc/popular_animes_bloc.dart';
import 'features/anime/presentation/bloc/search_animes_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  //Features - Anime
  //Bloc
  sl.registerFactory(() => RecentlyReleasedEpisodesBloc(
        getRecentlyReleasedEpisodes: sl(),
      ));
  sl.registerFactory(() => SearchAnimesBloc(
        getAnimesByTitle: sl(),
      ));
  sl.registerFactory(() => IframeUrlsBloc(
        getIframeUrlsById: sl(),
      ));
  sl.registerFactory(() => PopularAnimesBloc(
        getPopularAnimes: sl(),
      ));

  //Usecases
  sl.registerLazySingleton(() => GetAnimesByTitle(sl()));
  sl.registerLazySingleton(() => GetIframeUrlsById(sl()));
  sl.registerLazySingleton(() => GetOngoingAnimes(sl()));
  sl.registerLazySingleton(() => GetPopularAnimes(sl()));
  sl.registerLazySingleton(() => GetRecentlyAddedAnimes(sl()));
  sl.registerLazySingleton(() => GetRecentlyReleasedEpisodes(sl()));

  //Repositories
  sl.registerLazySingleton<AnimeRepository>(() => AnimeRepositoryImpl(
        animeRemoteDataSource: sl(),
        animeLocalDataSource: sl(),
        networkInfo: sl(),
      ));

  //Datasources
  sl.registerLazySingleton<AnimeRemoteDataSource>(() => AnimeRemoteDataSourceImpl(
        httpClient: sl(),
      ));
  sl.registerLazySingleton<AnimeLocalDataSource>(() => AnimeLocalDataSourceImpl(
        sharedPreferences: sl(),
      ));

  //Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //External
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
