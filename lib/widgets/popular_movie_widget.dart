import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/pages/detail_movie_page.dart';
import 'package:mini_project/providers/popular_movie_provider.dart';
import 'package:mini_project/widgets/item_movie_widget.dart';
import 'package:provider/provider.dart';

class PopularMovieWidget extends StatefulWidget {
  const PopularMovieWidget({super.key});

  @override
  State<PopularMovieWidget> createState() => _PopularMovieWidgetState();
}

class _PopularMovieWidgetState extends State<PopularMovieWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PopularMovieProvider>().getPopularMovie();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<PopularMovieProvider>(
        builder: (_, provider, __) {
          if (provider.isLoadingPopularMovie) {
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

          if (provider.popularMovie.isNotEmpty) {
            return CarouselSlider.builder(
              itemCount: provider.popularMovie.length,
              itemBuilder: (_, index, __) {
                final movie = provider.popularMovie[index];
                return ItemMovieWidget(
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
                'Not found popular movies',
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