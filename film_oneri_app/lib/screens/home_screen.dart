import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../services/app_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/shimmer_loading.dart';
import '../l10n/app_localizations.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _featuredController;
  int _currentFeaturedIndex = 0;

  // Data
  List<Movie> _trendingMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Genre> _genres = [];
  int _selectedGenreId = 0;
  List<Movie> _genreMovies = [];

  // Loading states
  bool _isLoadingTrending = true;
  bool _isLoadingTopRated = true;
  bool _isLoadingNowPlaying = true;
  bool _isLoadingUpcoming = true;
  bool _isLoadingGenres = true;
  bool _isLoadingGenreMovies = false;

  @override
  void initState() {
    super.initState();
    _featuredController = PageController(viewportFraction: 0.85);
    _loadData();
  }

  @override
  void dispose() {
    _featuredController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final provider = context.read<AppProvider>();
    final api = provider.apiService;

    // Trending
    try {
      final trending = await api.getTrendingMovies();
      if (mounted) {
        setState(() {
          _trendingMovies = provider.applyFavoriteStatus(trending);
          _isLoadingTrending = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingTrending = false);
    }

    // Top Rated
    try {
      final topRated = await api.getTopRatedMovies();
      if (mounted) {
        setState(() {
          _topRatedMovies = provider.applyFavoriteStatus(topRated);
          _isLoadingTopRated = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingTopRated = false);
    }

    // Now Playing
    try {
      final nowPlaying = await api.getNowPlayingMovies();
      if (mounted) {
        setState(() {
          _nowPlayingMovies = provider.applyFavoriteStatus(nowPlaying);
          _isLoadingNowPlaying = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingNowPlaying = false);
    }

    // Upcoming
    try {
      final upcoming = await api.getUpcomingMovies();
      if (mounted) {
        setState(() {
          _upcomingMovies = provider.applyFavoriteStatus(upcoming);
          _isLoadingUpcoming = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingUpcoming = false);
    }

    // Genres
    try {
      final genres = await api.getGenres();
      if (mounted) {
        setState(() {
          _genres = genres;
          _isLoadingGenres = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingGenres = false);
    }
  }

  Future<void> _loadGenreMovies(int genreId) async {
    if (genreId == 0) {
      setState(() {
        _genreMovies = [];
        _isLoadingGenreMovies = false;
      });
      return;
    }

    setState(() => _isLoadingGenreMovies = true);

    final provider = context.read<AppProvider>();
    try {
      final movies = await provider.apiService.getMoviesByGenre(genreId);
      if (mounted) {
        setState(() {
          _genreMovies = provider.applyFavoriteStatus(movies);
          _isLoadingGenreMovies = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingGenreMovies = false);
    }
  }

  void _navigateToDetail(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(movieId: movie.id),
      ),
    ).then((_) {
      // Favori durumunu güncelle
      final provider = context.read<AppProvider>();
      setState(() {
        _trendingMovies = provider.applyFavoriteStatus(_trendingMovies);
        _topRatedMovies = provider.applyFavoriteStatus(_topRatedMovies);
        _nowPlayingMovies = provider.applyFavoriteStatus(_nowPlayingMovies);
        _upcomingMovies = provider.applyFavoriteStatus(_upcomingMovies);
        _genreMovies = provider.applyFavoriteStatus(_genreMovies);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFFE50914),
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE50914), Color(0xFFB20710)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      const Icon(Icons.movie_filter, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  loc.appTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          // Featured / Trending Carousel
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Text(
                    loc.trending,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _isLoadingTrending
                    ? const SizedBox(
                        height: 220,
                        child: FeaturedCardShimmer(),
                      )
                    : SizedBox(
                        height: 220,
                        child: PageView.builder(
                          controller: _featuredController,
                          onPageChanged: (index) {
                            setState(() => _currentFeaturedIndex = index);
                          },
                          itemCount: _trendingMovies.take(10).length,
                          itemBuilder: (context, index) {
                            return FeaturedMovieCard(
                              movie: _trendingMovies[index],
                              isActive: _currentFeaturedIndex == index,
                              onTap: () =>
                                  _navigateToDetail(_trendingMovies[index]),
                            );
                          },
                        ),
                      ),
                // Page Indicator
                if (!_isLoadingTrending)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _trendingMovies.take(10).length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin:
                            const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                        width: _currentFeaturedIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentFeaturedIndex == index
                              ? const Color(0xFFE50914)
                              : Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Text(
                    loc.categories,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _isLoadingGenres
                    ? SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: 6,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ShimmerLoading(
                              width: 80,
                              height: 36,
                              borderRadius: 20,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: _genres.length + 1,
                          itemBuilder: (context, index) {
                            final isAll = index == 0;
                            final genre = isAll ? null : _genres[index - 1];
                            final isSelected = isAll
                                ? _selectedGenreId == 0
                                : _selectedGenreId == genre!.id;

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: FilterChip(
                                label: Text(isAll ? loc.all : genre!.name),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedGenreId = isAll ? 0 : genre!.id;
                                  });
                                  _loadGenreMovies(_selectedGenreId);
                                },
                                backgroundColor: Colors.grey.shade900,
                                selectedColor: const Color(0xFFE50914),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade400,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: isSelected
                                        ? const Color(0xFFE50914)
                                        : Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),

          // Genre Movies (if selected)
          if (_selectedGenreId != 0)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _isLoadingGenreMovies
                      ? const MovieListShimmer(height: 200)
                      : SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: _genreMovies.length,
                            itemBuilder: (context, index) {
                              return MovieCard(
                                movie: _genreMovies[index],
                                onTap: () =>
                                    _navigateToDetail(_genreMovies[index]),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),

          // Top Rated
          SliverToBoxAdapter(
            child: _buildMovieSection(
              title: loc.topRated,
              movies: _topRatedMovies,
              isLoading: _isLoadingTopRated,
            ),
          ),

          // Now Playing
          SliverToBoxAdapter(
            child: _buildMovieSection(
              title: loc.nowPlaying,
              movies: _nowPlayingMovies,
              isLoading: _isLoadingNowPlaying,
            ),
          ),

          // Upcoming
          SliverToBoxAdapter(
            child: _buildMovieSection(
              title: loc.upcoming,
              movies: _upcomingMovies,
              isLoading: _isLoadingUpcoming,
            ),
          ),

          // Bottom Padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieSection({
    required String title,
    required List<Movie> movies,
    required bool isLoading,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        isLoading
            ? const MovieListShimmer(height: 200)
            : SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return MovieCard(
                      movie: movies[index],
                      onTap: () => _navigateToDetail(movies[index]),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
