import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_project/models/favorite_movie_model.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'favorites';

  // Add movie to favorites
  Future<void> addToFavorites({
    required String userId,
    required int movieId,
    required String title,
    String? posterPath,
    required double voteAverage,
  }) async {
    try {
      final favorite = FavoriteMovie(
        userId: userId,
        movieId: movieId,
        title: title,
        posterPath: posterPath,
        voteAverage: voteAverage,
        addedAt: DateTime.now(),
      );

      await _firestore
          .collection(_collectionName)
          .doc(favorite.documentId)
          .set(favorite.toMap());
    } catch (e) {
      throw 'Gagal menambahkan ke favorit: ${e.toString()}';
    }
  }

  // Remove movie from favorites
  Future<void> removeFromFavorites({
    required String userId,
    required int movieId,
  }) async {
    try {
      final docId = '${userId}_$movieId';
      await _firestore.collection(_collectionName).doc(docId).delete();
    } catch (e) {
      throw 'Gagal menghapus dari favorit: ${e.toString()}';
    }
  }

  // Check if movie is in favorites
  Future<bool> isFavorite({
    required String userId,
    required int movieId,
  }) async {
    try {
      final docId = '${userId}_$movieId';
      final doc = await _firestore.collection(_collectionName).doc(docId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Get all favorites for a user
  Future<List<FavoriteMovie>> getFavorites(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('addedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => FavoriteMovie.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw 'Gagal mengambil favorit: ${e.toString()}';
    }
  }

  // Get favorites stream (real-time updates)
  Stream<List<FavoriteMovie>> getFavoritesStream(String userId) {
    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FavoriteMovie.fromFirestore(doc))
          .toList();
    });
  }

  // Get favorite count for a user
  Future<int> getFavoriteCount(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  // Toggle favorite (add if not exists, remove if exists)
  Future<bool> toggleFavorite({
    required String userId,
    required int movieId,
    required String title,
    String? posterPath,
    required double voteAverage,
  }) async {
    try {
      final isFav = await isFavorite(userId: userId, movieId: movieId);

      if (isFav) {
        await removeFromFavorites(userId: userId, movieId: movieId);
        return false; // Removed from favorites
      } else {
        await addToFavorites(
          userId: userId,
          movieId: movieId,
          title: title,
          posterPath: posterPath,
          voteAverage: voteAverage,
        );
        return true; // Added to favorites
      }
    } catch (e) {
      throw 'Gagal toggle favorit: ${e.toString()}';
    }
  }
}
