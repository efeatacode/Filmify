import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  // TMDB API Key - Kullanıcı kendi key'ini almalı: https://www.themoviedb.org/settings/api
  static const String _apiKey = 'a50dd130c4eafa3f6e779dd8133eac7f';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  
  String _language = 'tr-TR';
  
  void setLanguage(String languageCode) {
    _language = languageCode;
  }

  // Popüler Filmler
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=$_language&page=$page'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Popüler filmler yüklenemedi');
    }
  }

  // Trend Filmler
  Future<List<Movie>> getTrendingMovies({String timeWindow = 'week'}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/trending/movie/$timeWindow?api_key=$_apiKey&language=$_language'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Trend filmler yüklenemedi');
    }
  }

  // En Yüksek Puanlı Filmler
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/top_rated?api_key=$_apiKey&language=$_language&page=$page'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('En yüksek puanlı filmler yüklenemedi');
    }
  }

  // Vizyondaki Filmler
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/now_playing?api_key=$_apiKey&language=$_language&page=$page'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Vizyondaki filmler yüklenemedi');
    }
  }

  // Yakında Gelecek Filmler
  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/upcoming?api_key=$_apiKey&language=$_language&page=$page'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Yakında gelecek filmler yüklenemedi');
    }
  }

  // Film Detayı
  Future<MovieDetail> getMovieDetail(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey&language=$_language'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieDetail.fromJson(data);
    } else {
      throw Exception('Film detayı yüklenemedi');
    }
  }

  // Film Kredileri (Oyuncular & Ekip)
  Future<Credits> getMovieCredits(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId/credits?api_key=$_apiKey&language=$_language'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Credits.fromJson(data);
    } else {
      throw Exception('Film kredileri yüklenemedi');
    }
  }

  // Film Videoları (Fragmanlar)
  Future<List<Video>> getMovieVideos(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId/videos?api_key=$_apiKey&language=$_language'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      List<Video> videos = results.map((v) => Video.fromJson(v)).toList();
      
      // Eğer Türkçe video yoksa İngilizce dene
      if (videos.isEmpty && _language != 'en-US') {
        final enResponse = await http.get(
          Uri.parse('$_baseUrl/movie/$movieId/videos?api_key=$_apiKey&language=en-US'),
        );
        if (enResponse.statusCode == 200) {
          final enData = json.decode(enResponse.body);
          final enResults = enData['results'] as List;
          videos = enResults.map((v) => Video.fromJson(v)).toList();
        }
      }
      
      return videos;
    } else {
      throw Exception('Film videoları yüklenemedi');
    }
  }

  // Benzer Filmler
  Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId/similar?api_key=$_apiKey&language=$_language&page=$page'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Benzer filmler yüklenemedi');
    }
  }

  // Önerilen Filmler
  Future<List<Movie>> getRecommendedMovies(int movieId, {int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId/recommendations?api_key=$_apiKey&language=$_language&page=$page'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Önerilen filmler yüklenemedi');
    }
  }

  // Film Ara
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search/movie?api_key=$_apiKey&language=$_language&query=${Uri.encodeComponent(query)}&page=$page'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Arama yapılamadı');
    }
  }

  // Kategoriye Göre Film
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/discover/movie?api_key=$_apiKey&language=$_language&with_genres=$genreId&page=$page&sort_by=popularity.desc'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Kategori filmleri yüklenemedi');
    }
  }

  // Tüm Kategorileri Getir
  Future<List<Genre>> getGenres() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/genre/movie/list?api_key=$_apiKey&language=$_language'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final genres = data['genres'] as List;
      return genres.map((g) => Genre.fromJson(g)).toList();
    } else {
      throw Exception('Kategoriler yüklenemedi');
    }
  }

  // Kişi Detayı
  Future<Map<String, dynamic>> getPersonDetail(int personId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/person/$personId?api_key=$_apiKey&language=$_language'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Kişi detayı yüklenemedi');
    }
  }

  // Kişinin Filmleri
  Future<List<Movie>> getPersonMovies(int personId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/person/$personId/movie_credits?api_key=$_apiKey&language=$_language'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final cast = data['cast'] as List;
      return cast.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Kişinin filmleri yüklenemedi');
    }
  }
}
