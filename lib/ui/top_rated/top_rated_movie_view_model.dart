import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mini_project/models/repository/movie_repository.dart';
import 'package:mini_project/models/tmdb_responses/movie_response_model.dart';

class TopRatedMovieViewModel with ChangeNotifier {
  final MovieRepository _movieRepository;

  TopRatedMovieViewModel(
    this._movieRepository,
  );

  bool _isLoadingTopRatedMovie = false;
  bool get isLoadingPopularMovie => _isLoadingTopRatedMovie;

  final List<MovieModel> _movies = [];
  List<MovieModel> get movies => _movies;

  void getTopRatedMovie(BuildContext context) async {
    _isLoadingTopRatedMovie = true;
    notifyListeners();
    final result = await _movieRepository.getTopRated();

    result.fold(
      (errorMessage) {
        print(errorMessage);
        _isLoadingTopRatedMovie = false;
        notifyListeners();
        return;
      },
      (response) {
        _movies.clear();
        _movies.addAll(response.results);
        _isLoadingTopRatedMovie = false;
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
    final result = await _movieRepository.getTopRated(page: page);

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
