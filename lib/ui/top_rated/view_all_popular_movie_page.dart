import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mini_project/models/tmdb_responses/movie_response_model.dart';
import 'package:mini_project/ui/detail/detail_movie_page.dart';
import 'package:mini_project/ui/top_rated/top_rated_movie_view_model.dart';
import 'package:mini_project/widgets/item_movie_widget.dart';
import 'package:provider/provider.dart';

class ViewAllTopRatedMoviePage extends StatefulWidget {
  const ViewAllTopRatedMoviePage({super.key});

  @override
  State<ViewAllTopRatedMoviePage> createState() => _ViewAllTopRatedMoviePageState();
}

class _ViewAllTopRatedMoviePageState extends State<ViewAllTopRatedMoviePage> {
  final PagingController<int, MovieModel> _pagingController = PagingController(
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      context.read<TopRatedMovieViewModel>().getAllPopularMovie(
            context,
            pagingController: _pagingController,
            page: pageKey,
          );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Rated Movies"),
      ),
      body: PagedListView.separated(
        padding: const EdgeInsets.all(16),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<MovieModel>(
          itemBuilder: (context, item, index) => ItemMovieWidget(
            movie: item,
            height: 300,
            width: double.infinity,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return DetailMoviePage(
                      id: item.id,
                    );
                  },
                ),
              );
            },
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
