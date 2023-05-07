import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mini_project/models/api/movie_repository.dart';
import 'package:mini_project/models/tmdb_responses/movie_response_model.dart';

class PopularMovieProvider with ChangeNotifier {
  final MovieRepository _movieRepository;

  PopularMovieProvider(
    this._movieRepository,
  );

  bool _isLoadingPopularMovie = false;
  bool get isLoadingPopularMovie => _isLoadingPopularMovie;

  final List<MovieModel> _movies = [];
  List<MovieModel> get movies => _movies;

  void getPopularMovie(BuildContext context) async {
    _isLoadingPopularMovie = true;
    notifyListeners();
    final result = await _movieRepository.getDiscover();

    result.fold(
      (errorMessage) {
        print(errorMessage);
        _isLoadingPopularMovie = false;
        notifyListeners();
        return;
      },
      (response) {
        _movies.clear();
        _movies.addAll(response.results);
        _isLoadingPopularMovie = false;
        notifyListeners();
        return null;
      },
    );
  }

  void getAllPopularMovie(
    BuildContext context, {
    required PagingController pagingController,
    required int page,
  }) async {
    final result = await _movieRepository.getDiscover();

    result.fold(
      (errorMessage) {
        print(errorMessage);
        pagingController.error = errorMessage;
        return;
      },
      (response) {
        if (response.results.length < 20) {
          pagingController.appendLastPage(response.results);
        } else {
          pagingController.appendPage(response.results, page + 1);
        }
        return;
      },
    );
  }
}
