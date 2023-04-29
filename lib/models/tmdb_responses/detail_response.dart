import 'dart:convert';

class DetailMovieResponse {
    bool? adult;
    dynamic backdropPath;
    dynamic belongsToCollection;
    int? budget;
    List<dynamic>? genres;
    String? homepage;
    int? id;
    String? imdbId;
    String? originalLanguage;
    String? originalTitle;
    String? overview;
    double? popularity;
    dynamic posterPath;
    List<dynamic>? productionCompanies;
    List<ProductionCountry>? productionCountries;
    DateTime? releaseDate;
    int? revenue;
    int? runtime;
    List<SpokenLanguage>? spokenLanguages;
    String? status;
    String? tagline;
    String? title;
    bool? video;
    int? voteAverage;
    int? voteCount;

    DetailMovieResponse({
        this.adult,
        this.backdropPath,
        this.belongsToCollection,
        this.budget,
        this.genres,
        this.homepage,
        this.id,
        this.imdbId,
        this.originalLanguage,
        this.originalTitle,
        this.overview,
        this.popularity,
        this.posterPath,
        this.productionCompanies,
        this.productionCountries,
        this.releaseDate,
        this.revenue,
        this.runtime,
        this.spokenLanguages,
        this.status,
        this.tagline,
        this.title,
        this.video,
        this.voteAverage,
        this.voteCount,
    });

    factory DetailMovieResponse.fromJson(String str) => DetailMovieResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DetailMovieResponse.fromMap(Map<String, dynamic> json) => DetailMovieResponse(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        belongsToCollection: json["belongs_to_collection"],
        budget: json["budget"],
        genres: json["genres"] == null ? [] : List<dynamic>.from(json["genres"]!.map((x) => x)),
        homepage: json["homepage"],
        id: json["id"],
        imdbId: json["imdb_id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        productionCompanies: json["production_companies"] == null ? [] : List<dynamic>.from(json["production_companies"]!.map((x) => x)),
        productionCountries: json["production_countries"] == null ? [] : List<ProductionCountry>.from(json["production_countries"]!.map((x) => ProductionCountry.fromMap(x))),
        releaseDate: json["release_date"] == null ? null : DateTime.parse(json["release_date"]),
        revenue: json["revenue"],
        runtime: json["runtime"],
        spokenLanguages: json["spoken_languages"] == null ? [] : List<SpokenLanguage>.from(json["spoken_languages"]!.map((x) => SpokenLanguage.fromMap(x))),
        status: json["status"],
        tagline: json["tagline"],
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"],
        voteCount: json["vote_count"],
    );

    Map<String, dynamic> toMap() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "belongs_to_collection": belongsToCollection,
        "budget": budget,
        "genres": genres == null ? [] : List<dynamic>.from(genres!.map((x) => x)),
        "homepage": homepage,
        "id": id,
        "imdb_id": imdbId,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "production_companies": productionCompanies == null ? [] : List<dynamic>.from(productionCompanies!.map((x) => x)),
        "production_countries": productionCountries == null ? [] : List<dynamic>.from(productionCountries!.map((x) => x.toMap())),
        "release_date": "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
        "revenue": revenue,
        "runtime": runtime,
        "spoken_languages": spokenLanguages == null ? [] : List<dynamic>.from(spokenLanguages!.map((x) => x.toMap())),
        "status": status,
        "tagline": tagline,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
    };
}

class ProductionCountry {
    String? iso31661;
    String? name;

    ProductionCountry({
        this.iso31661,
        this.name,
    });

    factory ProductionCountry.fromJson(String str) => ProductionCountry.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProductionCountry.fromMap(Map<String, dynamic> json) => ProductionCountry(
        iso31661: json["iso_3166_1"],
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "iso_3166_1": iso31661,
        "name": name,
    };
}

class SpokenLanguage {
    String? englishName;
    String? iso6391;
    String? name;

    SpokenLanguage({
        this.englishName,
        this.iso6391,
        this.name,
    });

    factory SpokenLanguage.fromJson(String str) => SpokenLanguage.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SpokenLanguage.fromMap(Map<String, dynamic> json) => SpokenLanguage(
        englishName: json["english_name"],
        iso6391: json["iso_639_1"],
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "english_name": englishName,
        "iso_639_1": iso6391,
        "name": name,
    };
}
