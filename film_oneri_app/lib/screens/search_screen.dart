import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../services/app_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/shimmer_loading.dart';
import '../l10n/app_localizations.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<Movie> _searchResults = [];
  Map<int, String> _genreMap = {};
  bool _hasSearched = false;
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadGenres() async {
    final provider = context.read<AppProvider>();
    try {
      final genres = await provider.apiService.getGenres();
      if (mounted) {
        setState(() {
          _genreMap = {for (var g in genres) g.id: g.name};
        });
      }
    } catch (e) {
      // Ignore
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _search(query);
    });
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _hasSearched = false;
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _hasSearched = true;
      _isLoading = true;
    });

    final provider = context.read<AppProvider>();

    try {
      final results = await provider.apiService.searchMovies(query);
      
      // Son aramalara ekle
      provider.addRecentSearch(query);

      if (mounted) {
        setState(() {
          _searchResults = provider.applyFavoriteStatus(results);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToDetail(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(movieId: movie.id),
      ),
    ).then((_) {
      final provider = context.read<AppProvider>();
      setState(() {
        _searchResults = provider.applyFavoriteStatus(_searchResults);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final provider = context.watch<AppProvider>();

    return SafeArea(
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: loc.searchHint,
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                            _focusNode.unfocus();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // Results
          Expanded(
            child: _isLoading
                ? const SearchResultShimmer()
                : !_hasSearched
                    ? _buildSuggestions(provider, loc)
                    : _searchResults.isEmpty
                        ? _buildNoResults(loc)
                        : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(AppProvider provider, AppLocalizations loc) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (provider.recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loc.get('recent_searches'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    provider.clearRecentSearches();
                  },
                  child: Text(
                    loc.get('clear_history'),
                    style: const TextStyle(color: Color(0xFFE50914)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: provider.recentSearches
                  .map((search) => ActionChip(
                        avatar: const Icon(Icons.history, size: 16),
                        label: Text(search),
                        backgroundColor: Colors.grey.shade900,
                        onPressed: () {
                          _searchController.text = search;
                          _search(search);
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 32),
          ],

          // Popular Searches
          Text(
            loc.get('popular_searches'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Marvel',
              'Christopher Nolan',
              'Horror',
              'Comedy',
              'Sci-Fi',
              'Action',
              'Drama',
              'Animation',
            ]
                .map((tag) => ActionChip(
                      label: Text(tag),
                      backgroundColor: Colors.grey.shade900,
                      onPressed: () {
                        _searchController.text = tag;
                        _search(tag);
                      },
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey.shade700),
          const SizedBox(height: 16),
          Text(
            loc.noResults,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            loc.get('try_different'),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final movie = _searchResults[index];
        return SearchResultCard(
          movie: movie,
          genreMap: _genreMap,
          onTap: () => _navigateToDetail(movie),
        );
      },
    );
  }
}
