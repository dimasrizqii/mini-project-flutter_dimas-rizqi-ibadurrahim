import 'package:flutter/material.dart';
import 'package:mini_project/models/api/movie_api.dart';
import 'package:mini_project/models/tmdb_responses/popular_movie_response.dart';

class PopularMovieProvider with ChangeNotifier {
  List<PopularMovieModel> _popularMovie = [];
  List<PopularMovieModel> get popularMovie => _popularMovie;

  bool _isLoadingPopularMovie = false;
  bool get isLoadingPopularMovie => _isLoadingPopularMovie;

  bool _isEmptyPopularMovie = false;
  bool get isEmptyPopularMovie => _isEmptyPopularMovie;

  void getPopularMovie() async {
    _isLoadingPopularMovie = true;
    final result = await MovieApi().getPopularMovie();
    if (result.results.isEmpty) {
      _isEmptyPopularMovie = true;
    } else {
      _popularMovie = result.results;
    }
    _isLoadingPopularMovie = false;
    notifyListeners();
  }
}
