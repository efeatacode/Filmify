class Movie {
  final int id;
  final String title;
  final String originalTitle;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final String overview;
  final List<int> genreIds;
  final double popularity;
  final bool adult;
  final String originalLanguage;
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.overview,
    required this.genreIds,
    required this.popularity,
    required this.adult,
    required this.originalLanguage,
    this.isFavorite = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      originalTitle: json['original_title'] ?? json['original_name'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'] ?? json['first_air_date'] ?? '',
      overview: json['overview'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      popularity: (json['popularity'] ?? 0).toDouble(),
      adult: json['adult'] ?? false,
      originalLanguage: json['original_language'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'release_date': releaseDate,
      'overview': overview,
      'genre_ids': genreIds,
      'popularity': popularity,
      'adult': adult,
      'original_language': originalLanguage,
    };
  }

  String get posterUrl => posterPath.isNotEmpty
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : '';

  String get backdropUrl => backdropPath.isNotEmpty
      ? 'https://image.tmdb.org/t/p/original$backdropPath'
      : '';

  String get year => releaseDate.length >= 4 ? releaseDate.substring(0, 4) : '';
}

class MovieDetail {
  final int id;
  final String title;
  final String originalTitle;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final String overview;
  final List<Genre> genres;
  final int runtime;
  final String status;
  final String tagline;
  final int budget;
  final int revenue;
  final String homepage;
  final String imdbId;
  final List<ProductionCompany> productionCompanies;
  final List<SpokenLanguage> spokenLanguages;
  bool isFavorite;

  MovieDetail({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.overview,
    required this.genres,
    required this.runtime,
    required this.status,
    required this.tagline,
    required this.budget,
    required this.revenue,
    required this.homepage,
    required this.imdbId,
    required this.productionCompanies,
    required this.spokenLanguages,
    this.isFavorite = false,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      overview: json['overview'] ?? '',
      genres: (json['genres'] as List?)
              ?.map((g) => Genre.fromJson(g))
              .toList() ??
          [],
      runtime: json['runtime'] ?? 0,
      status: json['status'] ?? '',
      tagline: json['tagline'] ?? '',
      budget: json['budget'] ?? 0,
      revenue: json['revenue'] ?? 0,
      homepage: json['homepage'] ?? '',
      imdbId: json['imdb_id'] ?? '',
      productionCompanies: (json['production_companies'] as List?)
              ?.map((c) => ProductionCompany.fromJson(c))
              .toList() ??
          [],
      spokenLanguages: (json['spoken_languages'] as List?)
              ?.map((l) => SpokenLanguage.fromJson(l))
              .toList() ??
          [],
    );
  }

  String get posterUrl => posterPath.isNotEmpty
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : '';

  String get backdropUrl => backdropPath.isNotEmpty
      ? 'https://image.tmdb.org/t/p/original$backdropPath'
      : '';

  String get year => releaseDate.length >= 4 ? releaseDate.substring(0, 4) : '';

  String get formattedRuntime {
    if (runtime == 0) return '';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours > 0) {
      return '${hours}s ${minutes}dk';
    }
    return '${minutes}dk';
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class ProductionCompany {
  final int id;
  final String name;
  final String? logoPath;
  final String originCountry;

  ProductionCompany({
    required this.id,
    required this.name,
    this.logoPath,
    required this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logoPath: json['logo_path'],
      originCountry: json['origin_country'] ?? '',
    );
  }
}

class SpokenLanguage {
  final String englishName;
  final String iso6391;
  final String name;

  SpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) {
    return SpokenLanguage(
      englishName: json['english_name'] ?? '',
      iso6391: json['iso_639_1'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Cast {
  final int id;
  final String name;
  final String character;
  final String profilePath;
  final int order;

  Cast({
    required this.id,
    required this.name,
    required this.character,
    required this.profilePath,
    required this.order,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      profilePath: json['profile_path'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  String get profileUrl => profilePath.isNotEmpty
      ? 'https://image.tmdb.org/t/p/w185$profilePath'
      : '';
}

class Crew {
  final int id;
  final String name;
  final String job;
  final String department;
  final String profilePath;

  Crew({
    required this.id,
    required this.name,
    required this.job,
    required this.department,
    required this.profilePath,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      job: json['job'] ?? '',
      department: json['department'] ?? '',
      profilePath: json['profile_path'] ?? '',
    );
  }
}

class Video {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;
  final bool official;

  Video({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    required this.official,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
      official: json['official'] ?? false,
    );
  }

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';
  String get thumbnailUrl => 'https://img.youtube.com/vi/$key/hqdefault.jpg';
}

class Credits {
  final List<Cast> cast;
  final List<Crew> crew;

  Credits({required this.cast, required this.crew});

  factory Credits.fromJson(Map<String, dynamic> json) {
    return Credits(
      cast: (json['cast'] as List?)?.map((c) => Cast.fromJson(c)).toList() ?? [],
      crew: (json['crew'] as List?)?.map((c) => Crew.fromJson(c)).toList() ?? [],
    );
  }

  Crew? get director => crew.where((c) => c.job == 'Director').firstOrNull;
}
