import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class MovieCardShimmer extends StatelessWidget {
  final double width;
  final double height;

  const MovieCardShimmer({
    super.key,
    this.width = 130,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoading(
            width: width,
            height: height - 40,
            borderRadius: 12,
          ),
          const SizedBox(height: 8),
          ShimmerLoading(
            width: width * 0.8,
            height: 14,
            borderRadius: 4,
          ),
          const SizedBox(height: 4),
          ShimmerLoading(
            width: width * 0.4,
            height: 12,
            borderRadius: 4,
          ),
        ],
      ),
    );
  }
}

class MovieListShimmer extends StatelessWidget {
  final int itemCount;
  final double height;

  const MovieListShimmer({
    super.key,
    this.itemCount = 5,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return MovieCardShimmer(height: height);
        },
      ),
    );
  }
}

class FeaturedCardShimmer extends StatelessWidget {
  const FeaturedCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ShimmerLoading(
        width: double.infinity,
        height: 220,
        borderRadius: 16,
      ),
    );
  }
}

class MovieGridShimmer extends StatelessWidget {
  final int itemCount;

  const MovieGridShimmer({
    super.key,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return ShimmerLoading(
          width: double.infinity,
          height: double.infinity,
          borderRadius: 12,
        );
      },
    );
  }
}

class DetailShimmer extends StatelessWidget {
  const DetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Backdrop
          ShimmerLoading(
            width: double.infinity,
            height: 300,
            borderRadius: 0,
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const ShimmerLoading(width: 250, height: 28, borderRadius: 4),
                const SizedBox(height: 12),

                // Info Row
                Row(
                  children: [
                    ShimmerLoading(width: 60, height: 24, borderRadius: 4),
                    const SizedBox(width: 12),
                    ShimmerLoading(width: 50, height: 20, borderRadius: 4),
                    const SizedBox(width: 12),
                    ShimmerLoading(width: 60, height: 20, borderRadius: 4),
                  ],
                ),
                const SizedBox(height: 16),

                // Genres
                Row(
                  children: List.generate(
                    3,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ShimmerLoading(
                        width: 80,
                        height: 32,
                        borderRadius: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Button
                ShimmerLoading(
                  width: double.infinity,
                  height: 50,
                  borderRadius: 8,
                ),
                const SizedBox(height: 24),

                // Overview Title
                const ShimmerLoading(width: 80, height: 24, borderRadius: 4),
                const SizedBox(height: 12),

                // Overview Lines
                ...List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ShimmerLoading(
                      width: double.infinity,
                      height: 16,
                      borderRadius: 4,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Cast Title
                const ShimmerLoading(width: 100, height: 24, borderRadius: 4),
                const SizedBox(height: 12),

                // Cast List
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            ShimmerLoading(
                              width: 60,
                              height: 60,
                              borderRadius: 30,
                            ),
                            const SizedBox(height: 8),
                            const ShimmerLoading(
                              width: 70,
                              height: 12,
                              borderRadius: 4,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchResultShimmer extends StatelessWidget {
  final int itemCount;

  const SearchResultShimmer({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ShimmerLoading(width: 80, height: 120, borderRadius: 8),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerLoading(
                      width: double.infinity,
                      height: 18,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: 8),
                    ShimmerLoading(
                      width: 150,
                      height: 14,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ShimmerLoading(width: 50, height: 14, borderRadius: 4),
                        const SizedBox(width: 12),
                        ShimmerLoading(width: 40, height: 14, borderRadius: 4),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ShimmerLoading(width: 60, height: 24, borderRadius: 4),
                        const SizedBox(width: 8),
                        ShimmerLoading(width: 60, height: 24, borderRadius: 4),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
