import 'package:flutter/material.dart';
import 'package:mini_project/ui/detail/detail_movie_page.dart';
import 'package:mini_project/ui/top_rated/top_rated_movie_view_model.dart';
import 'package:mini_project/widgets/item_movie_widget.dart';
import 'package:mini_project/widgets/shimmer_loading.dart';
import 'package:provider/provider.dart';

class TopRatedMovieWidget extends StatefulWidget {
  const TopRatedMovieWidget({super.key});

  @override
  State<TopRatedMovieWidget> createState() => _TopRatedMovieWidgetState();
}

class _TopRatedMovieWidgetState extends State<TopRatedMovieWidget> {
  final PageController _pageController = PageController(viewportFraction: 0.8);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TopRatedMovieViewModel>().getTopRatedMovie(context);
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
      context.read<TopRatedMovieViewModel>().getTopRatedMovie(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Consumer<TopRatedMovieViewModel>(
          builder: (_, provider, __) {
            if (provider.isLoadingPopularMovie) {
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
                    "Failed to load Top Rated Movies",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<TopRatedMovieViewModel>()
                          .getTopRatedMovie(context);
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
