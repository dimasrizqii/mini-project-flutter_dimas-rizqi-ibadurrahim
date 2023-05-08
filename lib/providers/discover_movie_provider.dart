import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mini_project/models/repository/movie_repository.dart';
import 'package:mini_project/models/tmdb_responses/movie_response_model.dart';

class DiscoverMovieProvider with ChangeNotifier {
  final MovieRepository _movieRepository;

  DiscoverMovieProvider(
    this._movieRepository,
  );

  bool _isLoadingDiscoverMovie = false;
  bool get isLoadingDiscoverMovie => _isLoadingDiscoverMovie;

  final List<MovieModel> _movies = [];
  List<MovieModel> get movies => _movies;

  void getDiscoverMovie(BuildContext context) async {
    _isLoadingDiscoverMovie = true;
    notifyListeners();
    final result = await _movieRepository.getDiscover();

    result.fold(
      (errorMessage) {
        print(errorMessage);
        _isLoadingDiscoverMovie = false;
        notifyListeners();
        return;
      },
      (response) {
        _movies.clear();
        _movies.addAll(response.results);
        _isLoadingDiscoverMovie = false;
        notifyListeners();
        return null;
      },
    );
  }

  void getAllDiscoverMovie(
    BuildContext context, {
    required PagingController pagingController,
    required int page,
  }) async {
    final result = await _movieRepository.getDiscover(page: page);

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
