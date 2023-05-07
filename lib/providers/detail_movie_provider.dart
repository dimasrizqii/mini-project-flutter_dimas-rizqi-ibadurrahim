import 'package:flutter/material.dart';
import 'package:mini_project/models/api/movie_repository.dart';
import 'package:mini_project/models/tmdb_responses/detail_response.dart';

class DetailMovieProvider with ChangeNotifier {
  final MovieRepository _movieRepository;

  DetailMovieProvider(
    this._movieRepository,
  );

  DetailMovieModel? _movies;
  DetailMovieModel? get movies => _movies;

  bool _isLoadingDetailMovie = false;
  bool get isLoadingDetailMovie => _isLoadingDetailMovie;

  void getDetail(BuildContext context, {required int id}) async {
    _isLoadingDetailMovie = true;
    notifyListeners();
    final result = await _movieRepository.getDetail(id: id);
    result.fold(
      (messageError) {
        print(messageError);
        _isLoadingDetailMovie = false;
        _movies = null;
        notifyListeners();
        return;
      },
      (response) {
        _movies = response;
        notifyListeners();
        return;
      },
    );
  }
}
