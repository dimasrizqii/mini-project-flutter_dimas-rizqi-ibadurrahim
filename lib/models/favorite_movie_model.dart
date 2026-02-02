import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteMovie {
  final String userId;
  final int movieId;
  final String title;
  final String? posterPath;
  final double voteAverage;
  final DateTime addedAt;

  FavoriteMovie({
    required this.userId,
    required this.movieId,
    required this.title,
    this.posterPath,
    required this.voteAverage,
    required this.addedAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'movieId': movieId,
      'title': title,
      'posterPath': posterPath,
      'voteAverage': voteAverage,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  // Create from Map
  factory FavoriteMovie.fromMap(Map<String, dynamic> map) {
    return FavoriteMovie(
      userId: map['userId'] ?? '',
      movieId: map['movieId'] ?? 0,
      title: map['title'] ?? '',
      posterPath: map['posterPath'],
      voteAverage: (map['voteAverage'] ?? 0).toDouble(),
      addedAt: (map['addedAt'] as Timestamp).toDate(),
    );
  }

  // Create from Firestore DocumentSnapshot
  factory FavoriteMovie.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FavoriteMovie.fromMap(data);
  }

  // Document ID format: userId_movieId
  String get documentId => '${userId}_$movieId';

  // Copy with method
  FavoriteMovie copyWith({
    String? userId,
    int? movieId,
    String? title,
    String? posterPath,
    double? voteAverage,
    DateTime? addedAt,
  }) {
    return FavoriteMovie(
      userId: userId ?? this.userId,
      movieId: movieId ?? this.movieId,
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      voteAverage: voteAverage ?? this.voteAverage,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
