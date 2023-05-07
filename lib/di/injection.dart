import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:mini_project/constant/tmdb_api_constant.dart';
import 'package:mini_project/models/api/movie_repository.dart';
import 'package:mini_project/providers/detail_movie_provider.dart';
import 'package:mini_project/providers/discover_movie_provider.dart';
import 'package:mini_project/providers/popular_movie_provider.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerFactory<DiscoverMovieProvider>(
    () => DiscoverMovieProvider(
      getIt(),
    ),
  );
    getIt.registerFactory<PopularMovieProvider>(
    () => PopularMovieProvider(
      getIt(),
    ),
  );
  getIt.registerFactory<DetailMovieProvider>(
    () => DetailMovieProvider(
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
