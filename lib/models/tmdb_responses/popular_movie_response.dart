import 'dart:convert';

class PopularMovieResponse {
  int page;
  List<PopularMovieModel> results;
  int totalPages;
  int totalResults;

  PopularMovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory PopularMovieResponse.fromJson(String str) =>
      PopularMovieResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PopularMovieResponse.fromMap(Map<String, dynamic> json) =>
      PopularMovieResponse(
        page: json["page"],
        results: List<PopularMovieModel>.from(
            json["results"].map((x) => PopularMovieModel.fromMap(x))),
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
  String? backdropPath;
  int id;
  String overview;
  String? posterPath;
  String title;
  double voteAverage;
  int voteCount;

  PopularMovieModel({
    this.backdropPath,
    required this.id,
    required this.overview,
    this.posterPath,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  factory PopularMovieModel.fromJson(String str) =>
      PopularMovieModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PopularMovieModel.fromMap(Map<String, dynamic> json) =>
      PopularMovieModel(
        backdropPath: json["backdrop_path"],
        id: json["id"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        title: json["title"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toMap() => {
        "backdrop_path": backdropPath,
        "id": id,
        "overview": overview,
        "poster_path": posterPath,
        "title": title,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}
