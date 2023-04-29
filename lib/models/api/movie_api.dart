import 'package:dio/dio.dart';
import 'package:mini_project/constant/tmdb_api_constant.dart';
import 'package:mini_project/models/tmdb_responses/detail_response.dart';
import 'package:mini_project/models/tmdb_responses/discover_movie_response.dart';
import 'package:mini_project/models/tmdb_responses/popular_movie_response.dart';

class MovieApi {
  Future<PopularMovieResponse> getPopularMovie() async {
    try {
      final response =
          await Dio().get('$baseUrl/movie/popular/api_key=$apiKey');

      return PopularMovieResponse.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed Get Movie Popular $e');
    }
  }

  Future<DetailMovieResponse> getDetailMovie(String movieId) async {
    try {
      final response =
          await Dio().get('$baseUrl/movie/$movieId?api_key=$apiKey');

      return DetailMovieResponse.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed Get Detail Movie  $e');
    }
  }

  Future<DiscoverMovieResponse> getDiscoverMovie() async {
    try {
      final response = await Dio().get('$baseUrl/discover/movie/api_key=$apiKey');

      return DiscoverMovieResponse.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed Get Discover Movie  $e');
    }
  }
}
