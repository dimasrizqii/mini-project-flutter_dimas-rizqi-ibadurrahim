import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mini_project/models/api/movie_api.dart';
import 'package:mini_project/models/tmdb_responses/discover_movie_response.dart';

class DiscoverMovieProvider with ChangeNotifier {
  List<DiscoverMovieModel> _discoverMovie = [];
  List<DiscoverMovieModel> get discoverMovie => _discoverMovie;

  bool _isLoadingDiscoverMovie = false;
  bool get isLoadingDiscoverMovie => _isLoadingDiscoverMovie;

  bool _isEmptyDiscoverMovie = false;
  bool get isEmptyDiscoverMovie => _isEmptyDiscoverMovie;

  void getDiscoverMovie() async {
    _isLoadingDiscoverMovie = true;
    final result = await MovieApi().getDiscoverMovie();
    if (result.results.isEmpty) {
      _isEmptyDiscoverMovie = true;
    } else {
      _discoverMovie = result.results;
    }
    _isLoadingDiscoverMovie = false;
    notifyListeners();
  }

  void getDiscoverMovieWithPaging(
    BuildContext context, {
    required PagingController pagingController,
    required int page,
  }) async {
    final result = await MovieApi().getDiscoverMovie(page: page);

    if (result.results.length < 20) {
      pagingController.appendLastPage(result.results);
    } else {
      pagingController.appendPage(result.results, page + 1);
    }
    return;
  }
}
