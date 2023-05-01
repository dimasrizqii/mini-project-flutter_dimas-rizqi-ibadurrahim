import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/pages/detail_movie_page.dart';
import 'package:mini_project/providers/discover_movie_provider.dart';
import 'package:mini_project/widgets/item_movie_widget.dart';
import 'package:provider/provider.dart';

class DiscoverMovieWidget extends StatefulWidget {
  const DiscoverMovieWidget({super.key});

  @override
  State<DiscoverMovieWidget> createState() => _DiscoverMovieWidgetState();
}

class _DiscoverMovieWidgetState extends State<DiscoverMovieWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DiscoverMovieProvider>().getDiscoverMovie();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<DiscoverMovieProvider>(
        builder: (_, provider, __) {
          if (provider.isLoadingDiscoverMovie) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 300.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }

          if (provider.discoverMovie.isNotEmpty) {
            return CarouselSlider.builder(
              itemCount: provider.discoverMovie.length,
              itemBuilder: (_, index, __) {
                final movie = provider.discoverMovie[index];
                return ItemMovieWidget(
                  movie: movie,
                  heightBackdrop: 300,
                  widthBackdrop: double.infinity,
                  heightPoster: 160,
                  widthPoster: 100,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) {
                        return DetailMoviePage(id: movie.id);
                      },
                    ));
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
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 300.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Not found discover movies',
                style: TextStyle(
                  color: Colors.black45,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
