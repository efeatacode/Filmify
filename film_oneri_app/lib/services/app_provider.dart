import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // State
  Locale _locale = const Locale('tr');
  bool _isDarkMode = true;
  Set<int> _favoriteIds = {};
  List<Movie> _favorites = [];
  List<String> _recentSearches = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  Locale get locale => _locale;
  bool get isDarkMode => _isDarkMode;
  Set<int> get favoriteIds => _favoriteIds;
  List<Movie> get favorites => _favorites;
  List<String> get recentSearches => _recentSearches;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ApiService get apiService => _apiService;
  StorageService get storageService => _storageService;

  // API dil kodunu döndür
  String get apiLanguage {
    switch (_locale.languageCode) {
      case 'tr':
        return 'tr-TR';
      case 'en':
        return 'en-US';
      case 'de':
        return 'de-DE';
      case 'fr':
        return 'fr-FR';
      case 'es':
        return 'es-ES';
      default:
        return 'tr-TR';
    }
  }

  // Başlangıç yüklemesi
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Dil ayarını yükle
      final savedLang = await _storageService.loadLanguage();
      _locale = Locale(savedLang);
      _apiService.setLanguage(apiLanguage);

      // Tema ayarını yükle
      _isDarkMode = await _storageService.loadTheme();

      // Favorileri yükle
      _favorites = await _storageService.loadFavorites();
      _favoriteIds = _favorites.map((m) => m.id).toSet();

      // Son aramaları yükle
      _recentSearches = await _storageService.loadRecentSearches();

      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Dil değiştir
  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;

    _locale = newLocale;
    _apiService.setLanguage(apiLanguage);
    await _storageService.saveLanguage(newLocale.languageCode);
    notifyListeners();
  }

  // Tema değiştir
  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode == value) return;

    _isDarkMode = value;
    await _storageService.saveTheme(value);
    notifyListeners();
  }

  // Tema toggle
  Future<void> toggleTheme() async {
    await setDarkMode(!_isDarkMode);
  }

  // Favori durumunu kontrol et
  bool isFavorite(int movieId) {
    return _favoriteIds.contains(movieId);
  }

  // Favorilere ekle/çıkar
  Future<bool> toggleFavorite(Movie movie) async {
    if (_favoriteIds.contains(movie.id)) {
      // Çıkar
      _favoriteIds.remove(movie.id);
      _favorites.removeWhere((m) => m.id == movie.id);
      await _storageService.removeFavorite(movie.id);
      notifyListeners();
      return false;
    } else {
      // Ekle
      movie.isFavorite = true;
      _favoriteIds.add(movie.id);
      _favorites.insert(0, movie);
      await _storageService.addFavorite(movie);
      notifyListeners();
      return true;
    }
  }

  // Favorileri yenile
  Future<void> refreshFavorites() async {
    _favorites = await _storageService.loadFavorites();
    _favoriteIds = _favorites.map((m) => m.id).toSet();
    notifyListeners();
  }

  // Arama geçmişine ekle
  Future<void> addRecentSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    _recentSearches.remove(query);
    _recentSearches.insert(0, query);
    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.take(10).toList();
    }
    await _storageService.saveRecentSearches(_recentSearches);
    notifyListeners();
  }

  // Arama geçmişini temizle
  Future<void> clearRecentSearches() async {
    _recentSearches.clear();
    await _storageService.clearRecentSearches();
    notifyListeners();
  }

  // Film listesine favori durumunu ekle
  List<Movie> applyFavoriteStatus(List<Movie> movies) {
    for (var movie in movies) {
      movie.isFavorite = _favoriteIds.contains(movie.id);
    }
    return movies;
  }
}
