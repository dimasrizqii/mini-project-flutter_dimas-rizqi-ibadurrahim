import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mini_project/models/favorite_movie_model.dart';
import 'package:mini_project/services/favorites_service.dart';

class FavoritesViewModel extends ChangeNotifier {
  final FavoritesService _favoritesService;

  FavoritesViewModel(this._favoritesService);

  List<FavoriteMovie> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription? _favoritesSubscription;

  List<FavoriteMovie> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get favoritesCount => _favorites.length;

  // Load favorites for a user
  Future<void> loadFavorites(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _favorites = await _favoritesService.getFavorites(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Listen to favorites stream (real-time updates)
  void listenToFavorites(String userId) {
    _favoritesSubscription?.cancel();
    _favoritesSubscription =
        _favoritesService.getFavoritesStream(userId).listen(
      (favorites) {
        _favorites = favorites;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  // Add to favorites
  Future<bool> addToFavorites({
    required String userId,
    required int movieId,
    required String title,
    String? posterPath,
    required double voteAverage,
  }) async {
    try {
      await _favoritesService.addToFavorites(
        userId: userId,
        movieId: movieId,
        title: title,
        posterPath: posterPath,
        voteAverage: voteAverage,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Remove from favorites
  Future<bool> removeFromFavorites({
    required String userId,
    required int movieId,
  }) async {
    try {
      await _favoritesService.removeFromFavorites(
        userId: userId,
        movieId: movieId,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Toggle favorite
  Future<bool> toggleFavorite({
    required String userId,
    required int movieId,
    required String title,
    String? posterPath,
    required double voteAverage,
  }) async {
    try {
      final isNowFavorite = await _favoritesService.toggleFavorite(
        userId: userId,
        movieId: movieId,
        title: title,
        posterPath: posterPath,
        voteAverage: voteAverage,
      );
      return isNowFavorite;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Check if movie is favorite
  Future<bool> isFavorite({
    required String userId,
    required int movieId,
  }) async {
    try {
      return await _favoritesService.isFavorite(
        userId: userId,
        movieId: movieId,
      );
    } catch (e) {
      return false;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    super.dispose();
  }
}
