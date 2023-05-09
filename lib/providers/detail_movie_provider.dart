import 'package:flutter/material.dart';
import 'package:mini_project/models/repository/movie_repository.dart';
import 'package:mini_project/models/tmdb_responses/detail_movie_response_model.dart';

class DetailMovieProvider with ChangeNotifier {
  final MovieRepository _movieRepository;

  DetailMovieProvider(
    this._movieRepository,
  );

  DetailMovieResponseModel? _detailMovies;
  DetailMovieResponseModel? get detailMovies => _detailMovies;

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
        _detailMovies = null;
        notifyListeners();
        return;
      },
      (response) {
        _detailMovies = response;
        notifyListeners();
        return;
      },
    );
  }
}
