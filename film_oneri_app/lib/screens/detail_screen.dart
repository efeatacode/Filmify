import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/movie.dart';
import '../services/app_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/shimmer_loading.dart';
import '../l10n/app_localizations.dart';

class DetailScreen extends StatefulWidget {
  final int movieId;

  const DetailScreen({super.key, required this.movieId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  MovieDetail? _movieDetail;
  Credits? _credits;
  List<Video> _videos = [];
  List<Movie> _similarMovies = [];
  List<Movie> _recommendedMovies = [];

  bool _isLoading = true;
  bool _isFavorite = false;
  String? _error;

  YoutubePlayerController? _youtubeController;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _loadMovieDetail();
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  Future<void> _loadMovieDetail() async {
    final provider = context.read<AppProvider>();
    final api = provider.apiService;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Movie Detail
      final detail = await api.getMovieDetail(widget.movieId);
      _isFavorite = provider.isFavorite(widget.movieId);

      if (mounted) {
        setState(() {
          _movieDetail = detail;
          _movieDetail!.isFavorite = _isFavorite;
        });
      }

      // Credits
      try {
        final credits = await api.getMovieCredits(widget.movieId);
        if (mounted) setState(() => _credits = credits);
      } catch (e) {
        // Ignore
      }

      // Videos
      try {
        final videos = await api.getMovieVideos(widget.movieId);
        if (mounted) {
          setState(() => _videos = videos);
          _initYoutubePlayer();
        }
      } catch (e) {
        // Ignore
      }

      // Similar Movies
      try {
        final similar = await api.getSimilarMovies(widget.movieId);
        if (mounted) {
          setState(() {
            _similarMovies = provider.applyFavoriteStatus(similar);
          });
        }
      } catch (e) {
        // Ignore
      }

      // Recommended Movies
      try {
        final recommended = await api.getRecommendedMovies(widget.movieId);
        if (mounted) {
          setState(() {
            _recommendedMovies = provider.applyFavoriteStatus(recommended);
          });
        }
      } catch (e) {
        // Ignore
      }

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _initYoutubePlayer() {
    // Trailer veya Teaser bul
    final trailer = _videos.firstWhere(
      (v) => v.site == 'YouTube' && (v.type == 'Trailer' || v.type == 'Teaser'),
      orElse: () => _videos.firstWhere(
        (v) => v.site == 'YouTube',
        orElse: () => Video(
          id: '',
          key: '',
          name: '',
          site: '',
          type: '',
          official: false,
        ),
      ),
    );

    if (trailer.key.isNotEmpty) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: trailer.key,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
          forceHD: true,
        ),
      );
    }
  }

  Future<void> _toggleFavorite() async {
    if (_movieDetail == null) return;

    final provider = context.read<AppProvider>();

    // Movie model oluştur
    final movie = Movie(
      id: _movieDetail!.id,
      title: _movieDetail!.title,
      originalTitle: _movieDetail!.originalTitle,
      posterPath: _movieDetail!.posterPath,
      backdropPath: _movieDetail!.backdropPath,
      voteAverage: _movieDetail!.voteAverage,
      voteCount: _movieDetail!.voteCount,
      releaseDate: _movieDetail!.releaseDate,
      overview: _movieDetail!.overview,
      genreIds: _movieDetail!.genres.map((g) => g.id).toList(),
      popularity: 0,
      adult: false,
      originalLanguage: '',
    );

    final newStatus = await provider.toggleFavorite(movie);

    setState(() {
      _isFavorite = newStatus;
      _movieDetail!.isFavorite = newStatus;
    });

    if (mounted) {
      final loc = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus
                ? '${_movieDetail!.title} ${loc.get('added_to_favorites')}'
                : '${_movieDetail!.title} ${loc.get('removed_from_favorites')}',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _openTrailer(Video video) async {
    final url = Uri.parse(video.youtubeUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _showTrailerModal() {
    if (_videos.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TrailerModal(
        videos: _videos,
        onVideoTap: _openTrailer,
      ),
    );
  }

  void _showFullScreenPlayer() {
    if (_youtubeController == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullScreenPlayer(
          controller: _youtubeController!,
          title: _movieDetail?.title ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    if (_isLoading) {
      return Scaffold(
        body: const DetailShimmer(),
      );
    }

    if (_error != null || _movieDetail == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.grey.shade600),
              const SizedBox(height: 16),
              Text(
                loc.error,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadMovieDetail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50914),
                ),
                child: Text(loc.retry),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Backdrop
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF0D0D0D),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? const Color(0xFFE50914) : Colors.white,
                  ),
                ),
                onPressed: _toggleFavorite,
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share),
                ),
                onPressed: () {
                  // Share functionality
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Backdrop Image
                  _movieDetail!.backdropUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: _movieDetail!.backdropUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: Colors.grey.shade900,
                          ),
                        )
                      : Container(color: Colors.grey.shade900),

                  // Gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF0D0D0D).withOpacity(0.8),
                          const Color(0xFF0D0D0D),
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                    ),
                  ),

                  // Play Button (if has trailer)
                  if (_videos.isNotEmpty)
                    Center(
                      child: GestureDetector(
                        onTap: _showFullScreenPlayer,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE50914).withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _movieDetail!.title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_movieDetail!.tagline.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                _movieDetail!.tagline,
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE50914),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _movieDetail!.voteAverage
                                            .toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _movieDetail!.year,
                                  style: TextStyle(color: Colors.grey.shade400),
                                ),
                                if (_movieDetail!.formattedRuntime.isNotEmpty) ...[
                                  const SizedBox(width: 12),
                                  Text(
                                    _movieDetail!.formattedRuntime,
                                    style: TextStyle(color: Colors.grey.shade400),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Genres
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _movieDetail!.genres
                        .map((genre) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade700),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                genre.name,
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 13,
                                ),
                              ),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              _videos.isNotEmpty ? _showTrailerModal : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE50914),
                            disabledBackgroundColor: Colors.grey.shade800,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.play_arrow, color: Colors.white),
                          label: Text(
                            _videos.isNotEmpty
                                ? loc.watchTrailer
                                : loc.get('no_trailer'),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade700),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite
                                ? const Color(0xFFE50914)
                                : Colors.white,
                          ),
                          onPressed: _toggleFavorite,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Overview
                  Text(
                    loc.overview,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _movieDetail!.overview.isNotEmpty
                        ? _movieDetail!.overview
                        : 'Açıklama bulunamadı.',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Director
                  if (_credits?.director != null) ...[
                    Text(
                      loc.director,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _credits!.director!.profilePath.isNotEmpty
                            ? CircleAvatar(
                                radius: 24,
                                backgroundImage: CachedNetworkImageProvider(
                                  'https://image.tmdb.org/t/p/w185${_credits!.director!.profilePath}',
                                ),
                              )
                            : CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.grey.shade800,
                                child:
                                    const Icon(Icons.person, color: Colors.grey),
                              ),
                        const SizedBox(width: 12),
                        Text(
                          _credits!.director!.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Cast
                  if (_credits != null && _credits!.cast.isNotEmpty) ...[
                    Text(
                      loc.cast,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _credits!.cast.take(10).length,
                        itemBuilder: (context, index) {
                          final actor = _credits!.cast[index];
                          return Container(
                            width: 90,
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              children: [
                                actor.profileUrl.isNotEmpty
                                    ? CircleAvatar(
                                        radius: 35,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          actor.profileUrl,
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Colors.grey.shade800,
                                        child: Text(
                                          actor.name.isNotEmpty
                                              ? actor.name[0]
                                              : '?',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                const SizedBox(height: 8),
                                Text(
                                  actor.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (actor.character.isNotEmpty)
                                  Text(
                                    actor.character,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Similar Movies
                  if (_similarMovies.isNotEmpty) ...[
                    Text(
                      loc.similarMovies,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _similarMovies.length,
                        itemBuilder: (context, index) {
                          final movie = _similarMovies[index];
                          return MovieCard(
                            movie: movie,
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen(movieId: movie.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Recommended Movies
                  if (_recommendedMovies.isNotEmpty) ...[
                    Text(
                      loc.get('recommendations'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _recommendedMovies.length,
                        itemBuilder: (context, index) {
                          final movie = _recommendedMovies[index];
                          return MovieCard(
                            movie: movie,
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen(movieId: movie.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Trailer Modal
class _TrailerModal extends StatelessWidget {
  final List<Video> videos;
  final Function(Video) onVideoTap;

  const _TrailerModal({
    required this.videos,
    required this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Fragmanlar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    onVideoTap(video);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: video.thumbnailUrl,
                                width: 160,
                                height: 90,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Container(
                                  width: 160,
                                  height: 90,
                                  color: Colors.grey.shade800,
                                  child: const Icon(Icons.movie),
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.3),
                                  child: const Icon(
                                    Icons.play_circle_outline,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  video.type,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Full Screen Player
class _FullScreenPlayer extends StatefulWidget {
  final YoutubePlayerController controller;
  final String title;

  const _FullScreenPlayer({
    required this.controller,
    required this.title,
  });

  @override
  State<_FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<_FullScreenPlayer> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: YoutubePlayer(
              controller: widget.controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: const Color(0xFFE50914),
              progressColors: const ProgressBarColors(
                playedColor: Color(0xFFE50914),
                handleColor: Color(0xFFE50914),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
