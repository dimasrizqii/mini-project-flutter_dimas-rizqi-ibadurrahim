// To parse this JSON data, do
//
//     final popularMovieResponse = popularMovieResponseFromMap(jsonString);

import 'dart:convert';

class PopularMovieResponse {
    PopularMovieResponse({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    final int page;
    final List<PopularMovieModel> results;
    final int totalPages;
    final int totalResults;

    factory PopularMovieResponse.fromJson(String str) => PopularMovieResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PopularMovieResponse.fromMap(Map<String, dynamic> json) => PopularMovieResponse(
        page: json["page"],
        results: List<PopularMovieModel>.from(json["results"].map((x) => PopularMovieModel.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    Map<String, dynamic> toMap() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}

class PopularMovieModel {
    PopularMovieModel({
        required this.backdropPath,
        required this.id,
        required this.originalTitle,
        required this.overview,
        required this.popularity,
        required this.posterPath,
        required this.releaseDate,
        required this.title,
        required this.voteAverage,
        required this.voteCount,
    });


    final String backdropPath;
    final int id;
    final String originalTitle;
    final String overview;
    final double popularity;
    final String posterPath;
    final DateTime releaseDate;
    final String title;
    final double voteAverage;
    final int voteCount;

    factory PopularMovieModel.fromJson(String str) => PopularMovieModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PopularMovieModel.fromMap(Map<String, dynamic> json) => PopularMovieModel(
        backdropPath: json["backdrop_path"],
        id: json["id"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
    );

    Map<String, dynamic> toMap() => {
        "backdrop_path": backdropPath,
        "id": id,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": title,
        "vote_average": voteAverage,
        "vote_count": voteCount,
    };
}

// ignore: constant_identifier_names
enum OriginalLanguage { EN, ES, KO }

final originalLanguageValues = EnumValues({
    "en": OriginalLanguage.EN,
    "es": OriginalLanguage.ES,
    "ko": OriginalLanguage.KO
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
