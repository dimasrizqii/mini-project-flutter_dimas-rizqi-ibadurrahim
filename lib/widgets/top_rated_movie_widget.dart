import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/pages/detail_movie_page.dart';
import 'package:mini_project/providers/top_rated_movie_provider.dart';
import 'package:mini_project/widgets/item_movie_widget.dart';
import 'package:provider/provider.dart';

class TopRatedMovieWidget extends StatefulWidget {
  const TopRatedMovieWidget({super.key});

  @override
  State<TopRatedMovieWidget> createState() => _TopRatedMovieWidgetState();
}

class _TopRatedMovieWidgetState extends State<TopRatedMovieWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TopRatedMovieProvider>().getTopRatedMovie(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<TopRatedMovieProvider>(
        builder: (_, provider, __) {
          if (provider.isLoadingPopularMovie) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (provider.movies.isNotEmpty) {
            return CarouselSlider.builder(
              itemCount: provider.movies.length,
              itemBuilder: (_, index, __) {
                final movie = provider.movies[index];
                return ItemMovieWidget(
                  movie: movie,
                  height: 300,
                  width: double.infinity,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return DetailMoviePage(
                            id: movie.id,
                          );
                        },
                      ),
                    );
                  },
                );
              },
              options: CarouselOptions(
                height: 300.0,
                viewportFraction: 0.8,
                reverse: false,
                autoPlay: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
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
            child: const Center(
              child: Text(
                "Not Found Top Rated Movie",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
