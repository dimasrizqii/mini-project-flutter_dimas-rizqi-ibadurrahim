import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:mini_project/constant/tmdb_api_constant.dart';
import 'package:mini_project/models/repository/movie_repository.dart';
import 'package:mini_project/services/auth_service.dart';
import 'package:mini_project/services/favorites_service.dart';
import 'package:mini_project/ui/auth/auth_view_model.dart';
import 'package:mini_project/ui/detail/detail_movie_view_model.dart';
import 'package:mini_project/ui/discover/discover_movie_view_model.dart';
import 'package:mini_project/ui/favorites/favorites_view_model.dart';
import 'package:mini_project/ui/top_rated/top_rated_movie_view_model.dart';
import 'package:mini_project/ui/search/search_movie_view_model.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerFactory<DiscoverMovieViewModel>(
    () => DiscoverMovieViewModel(
      getIt(),
    ),
  );
  getIt.registerFactory<TopRatedMovieViewModel>(
    () => TopRatedMovieViewModel(
      getIt(),
    ),
  );
  getIt.registerFactory<DetailMovieViewModel>(
    () => DetailMovieViewModel(
      getIt(),
    ),
  );
  getIt.registerFactory<SearchMovieViewModel>(
    () => SearchMovieViewModel(
      getIt(),
    ),
  );

  // Authentication
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(),
  );

  getIt.registerFactory<AuthViewModel>(
    () => AuthViewModel(
      getIt(),
    ),
  );

  // Favorites
  getIt.registerLazySingleton<FavoritesService>(
    () => FavoritesService(),
  );

  getIt.registerFactory<FavoritesViewModel>(
    () => FavoritesViewModel(
      getIt(),
    ),
  );

  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      getIt(),
    ),
  );

  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: baseUrlMovie,
        queryParameters: {'api_key': apiKey},
      ),
    ),
  );
}
