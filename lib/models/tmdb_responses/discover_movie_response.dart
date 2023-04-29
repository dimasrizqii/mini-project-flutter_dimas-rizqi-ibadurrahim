import 'dart:convert';

class DiscoverMovieResponse {
  int page;
  List<DiscoverMovieModel> results;
  int totalPages;
  int totalResults;

  DiscoverMovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory DiscoverMovieResponse.fromJson(String str) =>
      DiscoverMovieResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DiscoverMovieResponse.fromMap(Map<String, dynamic> json) =>
      DiscoverMovieResponse(
        page: json["page"],
        results: List<DiscoverMovieModel>.from(
            json["results"].map((x) => DiscoverMovieModel.fromMap(x))),
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

class DiscoverMovieModel {
  String? backdropPath;
  int id;
  String overview;
  String? posterPath;
  String title;
  double voteAverage;
  int voteCount;

  DiscoverMovieModel({
    this.backdropPath,
    required this.id,
    required this.overview,
    this.posterPath,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  factory DiscoverMovieModel.fromJson(String str) =>
      DiscoverMovieModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DiscoverMovieModel.fromMap(Map<String, dynamic> json) =>
      DiscoverMovieModel(
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
