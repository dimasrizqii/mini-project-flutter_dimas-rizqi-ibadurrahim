import 'dart:async';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mini_project/models/repository/movie_repository.dart';
import 'package:mini_project/models/tmdb_responses/movie_response_model.dart';

class SearchMovieViewModel with ChangeNotifier {
  final MovieRepository _movieRepository;

  SearchMovieViewModel(this._movieRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _currentQuery = '';
  String get currentQuery => _currentQuery;

  Timer? _debounce;

  final List<MovieModel> _searchResults = [];
  List<MovieModel> get searchResults => _searchResults;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void searchMovies(
    BuildContext context, {
    required String query,
  }) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _currentQuery = query;

    if (query.isEmpty) {
      _searchResults.clear();
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(context, query);
    });
  }

  void _performSearch(BuildContext context, String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _movieRepository.searchMovies(query: query);

    result.fold(
      (errorMessage) {
        _errorMessage = errorMessage;
        _searchResults.clear();
        _isLoading = false;
        notifyListeners();
      },
      (response) {
        _searchResults.clear();
        _searchResults.addAll(response.results);
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void searchMoviesWithPagination(
    BuildContext context, {
    required PagingController pagingController,
    required int page,
    required String query,
  }) async {
    final result = await _movieRepository.searchMovies(
      query: query,
      page: page,
    );

    result.fold(
      (errorMessage) {
        pagingController.error = errorMessage;
      },
      (response) {
        if (response.results.length < 20) {
          pagingController.appendLastPage(response.results);
        } else {
          pagingController.appendPage(response.results, page + 1);
        }
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void clearSearch() {
    _searchResults.clear();
    _currentQuery = '';
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
