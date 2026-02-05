# 🎬 Film Öneri Uygulaması

Modern ve profesyonel bir Flutter film öneri uygulaması. TMDB API entegrasyonu, local storage, video player ve çoklu dil desteği ile tam donanımlı!

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Özellikler

### 🎥 TMDB API Entegrasyonu
- Gerçek film verileri (popüler, trend, en yüksek puanlılar, vizyondakiler, yakında)
- Detaylı film bilgileri (özet, yönetmen, oyuncular, süre, bütçe, hasılat)
- Film arama
- Kategoriye göre filtreleme
- Benzer film önerileri

### 💾 Local Storage (SharedPreferences)
- Favori filmleri kalıcı olarak kaydetme
- Son arama geçmişi
- Dil ve tema tercihleri

### 🎬 Video Player (YouTube)
- Fragman izleme (uygulama içi veya YouTube'da)
- Tam ekran player
- Birden fazla fragman desteği

### 🌍 Çoklu Dil Desteği
- 🇹🇷 Türkçe
- 🇬🇧 English
- 🇩🇪 Deutsch
- 🇫🇷 Français
- 🇪🇸 Español

### 🎨 Modern UI/UX
- Netflix/IMDb tarzı koyu tema
- Shimmer loading animasyonları
- Smooth geçişler ve animasyonlar
- Cached image loading
- Swipe-to-delete

## 📁 Proje Yapısı

```
lib/
├── main.dart                 # Ana uygulama
├── l10n/
│   └── app_localizations.dart # Çoklu dil
├── models/
│   └── movie.dart            # Veri modelleri
├── screens/
│   ├── home_screen.dart      # Ana sayfa
│   ├── search_screen.dart    # Arama
│   ├── favorites_screen.dart # Favoriler
│   ├── detail_screen.dart    # Film detay
│   └── settings_screen.dart  # Ayarlar
├── services/
│   ├── api_service.dart      # TMDB API
│   ├── storage_service.dart  # Local storage
│   └── app_provider.dart     # State management
└── widgets/
    ├── movie_card.dart       # Film kartları
    └── shimmer_loading.dart  # Loading shimmer
```

## 🚀 Kurulum

### 1. TMDB API Key Alma

1. [themoviedb.org](https://www.themoviedb.org/) adresine gidin
2. Ücretsiz hesap oluşturun
3. Settings > API bölümüne gidin
4. API Key (v3 auth) alın

### 2. Projeyi Kurma

```bash
# Projeyi oluşturun
flutter create film_oneri_app
cd film_oneri_app

# lib klasörünü bu projedeki ile değiştirin
# pubspec.yaml dosyasını değiştirin

# API key'i ayarlayın
# lib/services/api_service.dart dosyasını açın
# _apiKey değişkenine kendi key'inizi yazın:
# static const String _apiKey = 'YOUR_API_KEY_HERE';

# Bağımlılıkları yükleyin
flutter pub get

# Uygulamayı çalıştırın
flutter run
```

## 📦 Bağımlılıklar

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  provider: ^6.1.1           # State management
  http: ^1.1.0               # API calls
  shared_preferences: ^2.2.2 # Local storage
  cached_network_image: ^3.3.0 # Image caching
  url_launcher: ^6.2.1       # URL açma
  youtube_player_flutter: ^8.1.2 # YouTube player
  shimmer: ^3.0.0            # Loading animasyonları
  flutter_rating_bar: ^4.0.1 # Rating gösterimi
  intl: ^0.18.1              # Internationalization
```

## 📱 Ekran Görüntüleri

### Ana Sayfa
- Trend filmler carousel
- Kategori filtreleme
- En yüksek puanlılar
- Vizyondaki filmler

### Arama
- Gerçek zamanlı arama
- Son aramalar
- Popüler arama önerileri

### Favoriler
- Swipe ile silme
- Geri alma özelliği
- Favori sayısı

### Film Detay
- Backdrop görsel
- Film bilgileri
- Fragman izleme
- Oyuncu kadrosu
- Benzer filmler

### Ayarlar
- Dil seçimi
- Tema değiştirme
- Veri yönetimi

## 🛠️ API Endpoints Kullanılan

- `/movie/popular` - Popüler filmler
- `/trending/movie/{time_window}` - Trend filmler
- `/movie/top_rated` - En yüksek puanlılar
- `/movie/now_playing` - Vizyondakiler
- `/movie/upcoming` - Yakında gelecekler
- `/movie/{id}` - Film detayı
- `/movie/{id}/credits` - Oyuncular/Ekip
- `/movie/{id}/videos` - Fragmanlar
- `/movie/{id}/similar` - Benzer filmler
- `/movie/{id}/recommendations` - Önerilen filmler
- `/search/movie` - Film arama
- `/discover/movie` - Kategoriye göre
- `/genre/movie/list` - Tüm kategoriler

## 📄 Lisans

MIT License - Özgürce kullanabilirsiniz!

## 🤝 Katkıda Bulunma

Pull request'ler kabul edilir. Büyük değişiklikler için önce bir issue açınız.

---

⭐ Beğendiyseniz yıldız vermeyi unutmayın!

Made with ❤️ and Flutter
