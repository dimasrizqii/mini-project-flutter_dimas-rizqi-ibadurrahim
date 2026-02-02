import 'package:flutter/material.dart';
import 'package:mini_project/ui/detail/detail_movie_page.dart';
import 'package:mini_project/ui/discover/discover_movie_view_model.dart';
import 'package:mini_project/widgets/item_movie_widget.dart';
import 'package:mini_project/widgets/shimmer_loading.dart';
import 'package:provider/provider.dart';

class DiscoverMovieWidget extends StatefulWidget {
  const DiscoverMovieWidget({super.key});

  @override
  State<DiscoverMovieWidget> createState() => _DiscoverMovieWidgetState();
}

class _DiscoverMovieWidgetState extends State<DiscoverMovieWidget> {
  final PageController _pageController = PageController(viewportFraction: 0.8);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DiscoverMovieViewModel>().getDiscoverMovie(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      context.read<DiscoverMovieViewModel>().getDiscoverMovie(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Consumer<DiscoverMovieViewModel>(
          builder: (_, provider, __) {
            if (provider.isLoadingDiscoverMovie) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 300,
                child: const HorizontalMovieShimmer(),
              );
            }

            if (provider.movies.isNotEmpty) {
              return Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: provider.movies.length,
                      itemBuilder: (_, index) {
                        final movie = provider.movies[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ItemMovieWidget(
                            movie: movie,
                            height: 300,
                            width: double.infinity,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return DetailMoviePage(id: movie.id);
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.white54,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Failed to load Discover Movies",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<DiscoverMovieViewModel>()
                          .getDiscoverMovie(context);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
