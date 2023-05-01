import 'package:flutter/material.dart';
import 'package:mini_project/models/tmdb_responses/discover_movie_response.dart';
import 'package:mini_project/pages/detail_movie_page.dart';
import 'package:mini_project/providers/discover_movie_provider.dart';
import 'package:mini_project/providers/popular_movie_provider.dart';
import 'package:mini_project/widgets/item_movie_widget.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

enum TypeMovie { discover, popular }

class MoviePaginationPage extends StatefulWidget {
  const MoviePaginationPage({super.key, required this.type});

  final TypeMovie type;

  @override
  State<MoviePaginationPage> createState() => _MoviePaginationPageState();
}

class _MoviePaginationPageState extends State<MoviePaginationPage> {
  final PagingController<int, DiscoverMovieModel> _pagingController = PagingController(
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      switch (widget.type) {
        case TypeMovie.discover:
          context.read<DiscoverMovieProvider>().getDiscoverMovieWithPaging(
                context,
                pagingController: _pagingController,
                page: pageKey,
              );
          break;
        case TypeMovie.popular:
          context.read<PopularMovieProvider>().getPopularMovieWithPaging(
                context,
                pagingController: _pagingController,
                page: pageKey,
              );
          break;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Builder(builder: (_) {
          switch (widget.type) {
            case TypeMovie.discover:
              return const Text('Discover Movies');
            case TypeMovie.popular:
              return const Text('Popular Movies');
          }
        }),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: PagedListView.separated(
        padding: const EdgeInsets.all(16.0),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<DiscoverMovieModel>(
          itemBuilder: (context, item, index) => ItemMovieWidget(
            movie: item,
            heightBackdrop: 260,
            widthBackdrop: double.infinity,
            heightPoster: 140,
            widthPoster: 80,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) {
                  return DetailMoviePage(id: item.id);
                },
              ));
            },
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}