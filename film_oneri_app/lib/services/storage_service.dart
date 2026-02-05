import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

class StorageService {
  static const String _favoritesKey = 'favorite_movies';
  static const String _languageKey = 'app_language';
  static const String _themeKey = 'app_theme';
  static const String _recentSearchesKey = 'recent_searches';

  // ==================== FAVORİLER ====================

  // Favorileri Kaydet
  Future<void> saveFavorites(List<Movie> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = favorites.map((m) => json.encode(m.toJson())).toList();
    await prefs.setStringList(_favoritesKey, jsonList);
  }

  // Favorileri Yükle
  Future<List<Movie>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_favoritesKey) ?? [];
    return jsonList.map((jsonStr) {
      final movie = Movie.fromJson(json.decode(jsonStr));
      movie.isFavorite = true;
      return movie;
    }).toList();
  }

  // Favorilere Ekle
  Future<void> addFavorite(Movie movie) async {
    final favorites = await loadFavorites();
    if (!favorites.any((m) => m.id == movie.id)) {
      movie.isFavorite = true;
      favorites.add(movie);
      await saveFavorites(favorites);
    }
  }

  // Favorilerden Kaldır
  Future<void> removeFavorite(int movieId) async {
    final favorites = await loadFavorites();
    favorites.removeWhere((m) => m.id == movieId);
    await saveFavorites(favorites);
  }

  // Favori mi Kontrol Et
  Future<bool> isFavorite(int movieId) async {
    final favorites = await loadFavorites();
    return favorites.any((m) => m.id == movieId);
  }

  // Favori Durumunu Değiştir
  Future<bool> toggleFavorite(Movie movie) async {
    final isFav = await isFavorite(movie.id);
    if (isFav) {
      await removeFavorite(movie.id);
      return false;
    } else {
      await addFavorite(movie);
      return true;
    }
  }

  // Favori ID'lerini Al
  Future<Set<int>> getFavoriteIds() async {
    final favorites = await loadFavorites();
    return favorites.map((m) => m.id).toSet();
  }

  // ==================== DİL AYARLARI ====================

  // Dili Kaydet
  Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  // Dili Yükle
  Future<String> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'tr';
  }

  // ==================== TEMA AYARLARI ====================

  // Temayı Kaydet
  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  // Temayı Yükle
  Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? true; // Varsayılan dark
  }

  // ==================== SON ARAMALAR ====================

  // Son Aramaları Kaydet
  Future<void> saveRecentSearches(List<String> searches) async {
    final prefs = await SharedPreferences.getInstance();
    // Son 10 aramayı tut
    final trimmed = searches.take(10).toList();
    await prefs.setStringList(_recentSearchesKey, trimmed);
  }

  // Son Aramaları Yükle
  Future<List<String>> loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentSearchesKey) ?? [];
  }

  // Arama Ekle
  Future<void> addRecentSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    final searches = await loadRecentSearches();
    // Zaten varsa çıkar (başa eklemek için)
    searches.remove(query);
    // Başa ekle
    searches.insert(0, query);
    await saveRecentSearches(searches);
  }

  // Son Aramaları Temizle
  Future<void> clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentSearchesKey);
  }

  // ==================== GENEL ====================

  // Tüm Verileri Temizle
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
