import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'tr': {
      // Genel
      'app_title': 'Film Öneri',
      'loading': 'Yükleniyor...',
      'error': 'Hata',
      'retry': 'Tekrar Dene',
      'cancel': 'İptal',
      'ok': 'Tamam',
      'save': 'Kaydet',
      'delete': 'Sil',
      'share': 'Paylaş',
      'close': 'Kapat',
      
      // Navigasyon
      'home': 'Ana Sayfa',
      'search': 'Ara',
      'favorites': 'Favoriler',
      'settings': 'Ayarlar',
      
      // Ana Sayfa
      'featured': '🔥 Öne Çıkanlar',
      'trending': '📈 Trend Filmler',
      'top_rated': '⭐ En Yüksek Puanlılar',
      'now_playing': '🎬 Vizyonda',
      'upcoming': '📅 Yakında',
      'categories': '🎭 Kategoriler',
      'all_movies': '🎬 Tüm Filmler',
      'all': 'Tümü',
      
      // Arama
      'search_hint': 'Film, yönetmen, oyuncu ara...',
      'popular_searches': '🔍 Popüler Aramalar',
      'recent_searches': '⏱️ Son Aramalar',
      'no_results': 'Sonuç bulunamadı',
      'try_different': 'Farklı kelimelerle aramayı deneyin',
      'clear_history': 'Geçmişi Temizle',
      
      // Favoriler
      'my_favorites': '❤️ Favorilerim',
      'no_favorites': 'Henüz favori film yok',
      'add_favorites_hint': 'Beğendiğin filmleri ❤️ ile favorilere ekle',
      'removed_from_favorites': 'Favorilerden kaldırıldı',
      'added_to_favorites': 'Favorilere eklendi',
      'undo': 'Geri Al',
      
      // Film Detay
      'overview': 'Özet',
      'director': 'Yönetmen',
      'cast': 'Oyuncular',
      'similar_movies': 'Benzer Filmler',
      'recommendations': 'Önerilen Filmler',
      'watch_trailer': 'Fragman İzle',
      'trailers': 'Fragmanlar',
      'no_trailer': 'Fragman bulunamadı',
      'runtime': 'Süre',
      'release_date': 'Çıkış Tarihi',
      'budget': 'Bütçe',
      'revenue': 'Hasılat',
      'status': 'Durum',
      'original_title': 'Orijinal İsim',
      'production': 'Yapımcı',
      
      // Ayarlar
      'language': 'Dil',
      'theme': 'Tema',
      'dark_mode': 'Karanlık Mod',
      'light_mode': 'Aydınlık Mod',
      'about': 'Hakkında',
      'version': 'Versiyon',
      'clear_cache': 'Önbelleği Temizle',
      'clear_data': 'Verileri Temizle',
      'rate_app': 'Uygulamayı Değerlendir',
      'privacy_policy': 'Gizlilik Politikası',
      'terms_of_service': 'Kullanım Koşulları',
      
      // Kategoriler
      'action': 'Aksiyon',
      'adventure': 'Macera',
      'animation': 'Animasyon',
      'comedy': 'Komedi',
      'crime': 'Suç',
      'documentary': 'Belgesel',
      'drama': 'Dram',
      'family': 'Aile',
      'fantasy': 'Fantastik',
      'history': 'Tarih',
      'horror': 'Korku',
      'music': 'Müzik',
      'mystery': 'Gizem',
      'romance': 'Romantik',
      'science_fiction': 'Bilim Kurgu',
      'thriller': 'Gerilim',
      'war': 'Savaş',
      'western': 'Western',
      
      // API Hataları
      'api_error': 'Veri yüklenirken bir hata oluştu',
      'no_internet': 'İnternet bağlantısı yok',
      'server_error': 'Sunucu hatası',
      'timeout': 'Bağlantı zaman aşımı',
    },
    'en': {
      // General
      'app_title': 'Movie Recommender',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'cancel': 'Cancel',
      'ok': 'OK',
      'save': 'Save',
      'delete': 'Delete',
      'share': 'Share',
      'close': 'Close',
      
      // Navigation
      'home': 'Home',
      'search': 'Search',
      'favorites': 'Favorites',
      'settings': 'Settings',
      
      // Home
      'featured': '🔥 Featured',
      'trending': '📈 Trending',
      'top_rated': '⭐ Top Rated',
      'now_playing': '🎬 Now Playing',
      'upcoming': '📅 Upcoming',
      'categories': '🎭 Categories',
      'all_movies': '🎬 All Movies',
      'all': 'All',
      
      // Search
      'search_hint': 'Search movies, directors, actors...',
      'popular_searches': '🔍 Popular Searches',
      'recent_searches': '⏱️ Recent Searches',
      'no_results': 'No results found',
      'try_different': 'Try different keywords',
      'clear_history': 'Clear History',
      
      // Favorites
      'my_favorites': '❤️ My Favorites',
      'no_favorites': 'No favorite movies yet',
      'add_favorites_hint': 'Add movies to favorites with ❤️',
      'removed_from_favorites': 'Removed from favorites',
      'added_to_favorites': 'Added to favorites',
      'undo': 'Undo',
      
      // Movie Detail
      'overview': 'Overview',
      'director': 'Director',
      'cast': 'Cast',
      'similar_movies': 'Similar Movies',
      'recommendations': 'Recommendations',
      'watch_trailer': 'Watch Trailer',
      'trailers': 'Trailers',
      'no_trailer': 'No trailer available',
      'runtime': 'Runtime',
      'release_date': 'Release Date',
      'budget': 'Budget',
      'revenue': 'Revenue',
      'status': 'Status',
      'original_title': 'Original Title',
      'production': 'Production',
      
      // Settings
      'language': 'Language',
      'theme': 'Theme',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'about': 'About',
      'version': 'Version',
      'clear_cache': 'Clear Cache',
      'clear_data': 'Clear Data',
      'rate_app': 'Rate App',
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',
      
      // Categories
      'action': 'Action',
      'adventure': 'Adventure',
      'animation': 'Animation',
      'comedy': 'Comedy',
      'crime': 'Crime',
      'documentary': 'Documentary',
      'drama': 'Drama',
      'family': 'Family',
      'fantasy': 'Fantasy',
      'history': 'History',
      'horror': 'Horror',
      'music': 'Music',
      'mystery': 'Mystery',
      'romance': 'Romance',
      'science_fiction': 'Science Fiction',
      'thriller': 'Thriller',
      'war': 'War',
      'western': 'Western',
      
      // API Errors
      'api_error': 'An error occurred while loading data',
      'no_internet': 'No internet connection',
      'server_error': 'Server error',
      'timeout': 'Connection timeout',
    },
    'de': {
      'app_title': 'Film Empfehlung',
      'loading': 'Laden...',
      'error': 'Fehler',
      'retry': 'Erneut versuchen',
      'cancel': 'Abbrechen',
      'ok': 'OK',
      'home': 'Startseite',
      'search': 'Suche',
      'favorites': 'Favoriten',
      'settings': 'Einstellungen',
      'featured': '🔥 Empfohlen',
      'trending': '📈 Im Trend',
      'top_rated': '⭐ Bestbewertet',
      'now_playing': '🎬 Im Kino',
      'upcoming': '📅 Demnächst',
      'categories': '🎭 Kategorien',
      'all_movies': '🎬 Alle Filme',
      'all': 'Alle',
      'search_hint': 'Filme, Regisseure, Schauspieler suchen...',
      'no_results': 'Keine Ergebnisse gefunden',
      'my_favorites': '❤️ Meine Favoriten',
      'no_favorites': 'Noch keine Lieblingsfilme',
      'overview': 'Übersicht',
      'director': 'Regisseur',
      'cast': 'Besetzung',
      'similar_movies': 'Ähnliche Filme',
      'watch_trailer': 'Trailer ansehen',
      'language': 'Sprache',
      'theme': 'Thema',
      'dark_mode': 'Dunkelmodus',
    },
    'fr': {
      'app_title': 'Recommandation de Films',
      'loading': 'Chargement...',
      'error': 'Erreur',
      'retry': 'Réessayer',
      'cancel': 'Annuler',
      'ok': 'OK',
      'home': 'Accueil',
      'search': 'Recherche',
      'favorites': 'Favoris',
      'settings': 'Paramètres',
      'featured': '🔥 En vedette',
      'trending': '📈 Tendances',
      'top_rated': '⭐ Les mieux notés',
      'now_playing': '🎬 À laffiche',
      'upcoming': '📅 Prochainement',
      'categories': '🎭 Catégories',
      'all_movies': '🎬 Tous les films',
      'all': 'Tous',
      'search_hint': 'Rechercher des films, réalisateurs, acteurs...',
      'no_results': 'Aucun résultat trouvé',
      'my_favorites': '❤️ Mes favoris',
      'no_favorites': 'Pas encore de films favoris',
      'overview': 'Synopsis',
      'director': 'Réalisateur',
      'cast': 'Distribution',
      'similar_movies': 'Films similaires',
      'watch_trailer': 'Voir la bande-annonce',
      'language': 'Langue',
      'theme': 'Thème',
      'dark_mode': 'Mode sombre',
    },
    'es': {
      'app_title': 'Recomendador de Películas',
      'loading': 'Cargando...',
      'error': 'Error',
      'retry': 'Reintentar',
      'cancel': 'Cancelar',
      'ok': 'OK',
      'home': 'Inicio',
      'search': 'Buscar',
      'favorites': 'Favoritos',
      'settings': 'Configuración',
      'featured': '🔥 Destacados',
      'trending': '📈 Tendencias',
      'top_rated': '⭐ Mejor valorados',
      'now_playing': '🎬 En cartelera',
      'upcoming': '📅 Próximamente',
      'categories': '🎭 Categorías',
      'all_movies': '🎬 Todas las películas',
      'all': 'Todos',
      'search_hint': 'Buscar películas, directores, actores...',
      'no_results': 'No se encontraron resultados',
      'my_favorites': '❤️ Mis favoritos',
      'no_favorites': 'Aún no hay películas favoritas',
      'overview': 'Sinopsis',
      'director': 'Director',
      'cast': 'Reparto',
      'similar_movies': 'Películas similares',
      'watch_trailer': 'Ver tráiler',
      'language': 'Idioma',
      'theme': 'Tema',
      'dark_mode': 'Modo oscuro',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  // Kısayollar
  String get appTitle => get('app_title');
  String get loading => get('loading');
  String get error => get('error');
  String get retry => get('retry');
  String get home => get('home');
  String get search => get('search');
  String get favorites => get('favorites');
  String get settings => get('settings');
  String get featured => get('featured');
  String get trending => get('trending');
  String get topRated => get('top_rated');
  String get nowPlaying => get('now_playing');
  String get upcoming => get('upcoming');
  String get categories => get('categories');
  String get allMovies => get('all_movies');
  String get all => get('all');
  String get searchHint => get('search_hint');
  String get noResults => get('no_results');
  String get myFavorites => get('my_favorites');
  String get noFavorites => get('no_favorites');
  String get overview => get('overview');
  String get director => get('director');
  String get cast => get('cast');
  String get similarMovies => get('similar_movies');
  String get watchTrailer => get('watch_trailer');
  String get language => get('language');
  String get theme => get('theme');
  String get darkMode => get('dark_mode');

  static List<Locale> get supportedLocales => const [
    Locale('tr'),
    Locale('en'),
    Locale('de'),
    Locale('fr'),
    Locale('es'),
  ];

  static Map<String, String> get languageNames => {
    'tr': 'Türkçe',
    'en': 'English',
    'de': 'Deutsch',
    'fr': 'Français',
    'es': 'Español',
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['tr', 'en', 'de', 'fr', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
