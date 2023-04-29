import 'package:flutter/material.dart';
import 'package:mini_project/models/api/movie_api.dart';
import 'package:mini_project/models/tmdb_responses/detail_response.dart';

class DetailMovieProvider with ChangeNotifier {
  DetailMovieResponse _detailMovieResponse = DetailMovieResponse();
  DetailMovieResponse get detailMovieResponse => _detailMovieResponse;
  bool _isLoadingDetailMovie = false;
  bool get isLoadingDetailMovie => _isLoadingDetailMovie;

  void getDetailMovie(String movieId) async {
    _isLoadingDetailMovie = true;
    _detailMovieResponse = await MovieApi().getDetailMovie(movieId);
    _isLoadingDetailMovie = false;
    notifyListeners();
  }
}
