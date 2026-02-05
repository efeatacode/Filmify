import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final provider = context.watch<AppProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.settings,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Language Section
            _buildSectionTitle(loc.language),
            const SizedBox(height: 12),
            _buildLanguageSelector(context, provider),
            const SizedBox(height: 24),

            // Theme Section
            _buildSectionTitle(loc.theme),
            const SizedBox(height: 12),
            _buildThemeToggle(context, provider, loc),
            const SizedBox(height: 24),

            // Data Section
            _buildSectionTitle('Veri'),
            const SizedBox(height: 12),
            _buildDataOptions(context, provider, loc),
            const SizedBox(height: 24),

            // About Section
            _buildSectionTitle(loc.get('about')),
            const SizedBox(height: 12),
            _buildAboutSection(context, loc),
            const SizedBox(height: 24),

            // API Key Info
            _buildApiKeyInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFFE50914),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, AppProvider provider) {
    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: AppLocalizations.languageNames.entries.map((entry) {
          final isSelected = provider.locale.languageCode == entry.key;
          return ListTile(
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFE50914)
                    : Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _getLanguageEmoji(entry.key),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            title: Text(
              entry.value,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: isSelected
                ? const Icon(Icons.check_circle, color: Color(0xFFE50914))
                : null,
            onTap: () async {
              await provider.setLocale(Locale(entry.key));
            },
          );
        }).toList(),
      ),
    );
  }

  String _getLanguageEmoji(String code) {
    switch (code) {
      case 'tr':
        return '🇹🇷';
      case 'en':
        return '🇬🇧';
      case 'de':
        return '🇩🇪';
      case 'fr':
        return '🇫🇷';
      case 'es':
        return '🇪🇸';
      default:
        return '🌐';
    }
  }

  Widget _buildThemeToggle(
    BuildContext context,
    AppProvider provider,
    AppLocalizations loc,
  ) {
    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            shape: BoxShape.circle,
          ),
          child: Icon(
            provider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: provider.isDarkMode ? Colors.amber : Colors.orange,
          ),
        ),
        title: Text(provider.isDarkMode ? loc.darkMode : loc.get('light_mode')),
        subtitle: Text(
          provider.isDarkMode
              ? 'Karanlık tema aktif'
              : 'Aydınlık tema aktif',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
        trailing: Switch(
          value: provider.isDarkMode,
          activeColor: const Color(0xFFE50914),
          onChanged: (value) async {
            await provider.setDarkMode(value);
          },
        ),
      ),
    );
  }

  Widget _buildDataOptions(
    BuildContext context,
    AppProvider provider,
    AppLocalizations loc,
  ) {
    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.history, color: Colors.blue),
            ),
            title: const Text('Arama Geçmişini Temizle'),
            subtitle: Text(
              '${provider.recentSearches.length} kayıt',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.grey.shade900,
                  title: const Text('Arama Geçmişini Temizle'),
                  content: const Text(
                    'Tüm arama geçmişi silinecek. Devam etmek istiyor musunuz?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        loc.get('cancel'),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        'Temizle',
                        style: TextStyle(color: Color(0xFFE50914)),
                      ),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await provider.clearRecentSearches();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Arama geçmişi temizlendi'),
                    ),
                  );
                }
              }
            },
          ),
          const Divider(height: 1, color: Colors.grey),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, color: Color(0xFFE50914)),
            ),
            title: const Text('Favoriler'),
            subtitle: Text(
              '${provider.favorites.length} film',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, AppLocalizations loc) {
    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.info_outline, color: Colors.blue),
            ),
            title: const Text('Versiyon'),
            trailing: Text(
              '1.0.0',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.movie, color: Colors.amber),
            ),
            title: const Text('Film Verileri'),
            subtitle: Text(
              'TMDB API tarafından sağlanmaktadır',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
            trailing: const Icon(Icons.open_in_new, color: Colors.grey, size: 18),
          ),
          const Divider(height: 1, color: Colors.grey),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.code, color: Colors.green),
            ),
            title: const Text('Geliştirici'),
            subtitle: Text(
              'Flutter ile geliştirildi',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApiKeyInfo(BuildContext context) {
    return Card(
      color: const Color(0xFFE50914).withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE50914), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.key, color: Color(0xFFE50914)),
                const SizedBox(width: 8),
                const Text(
                  'TMDB API Key',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Bu uygulama TMDB API kullanmaktadır. Uygulamanın çalışması için:\n\n'
              '1. themoviedb.org adresinden ücretsiz hesap oluşturun\n'
              '2. Settings > API bölümünden API key alın\n'
              '3. lib/services/api_service.dart dosyasındaki\n'
              '   _apiKey değişkenine key\'inizi yazın',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link, color: Colors.blue, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'themoviedb.org/settings/api',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
