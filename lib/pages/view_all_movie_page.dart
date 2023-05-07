import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mini_project/models/tmdb_responses/movie_response_model.dart';
import 'package:mini_project/pages/detail_movie_page.dart';
import 'package:mini_project/providers/discover_movie_provider.dart';
import 'package:mini_project/widgets/item_movie_widget.dart';
import 'package:provider/provider.dart';

class ViewAllMoviePage extends StatefulWidget {
  const ViewAllMoviePage({super.key});

  @override
  State<ViewAllMoviePage> createState() => _ViewAllMoviePageState();
}

class _ViewAllMoviePageState extends State<ViewAllMoviePage> {
  final PagingController<int, MovieModel> _pagingController = PagingController(
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      context.read<DiscoverMovieProvider>().getAllDiscoverMovie(
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
        title: const Text("Discover Movies"),
      ),
      body: PagedListView.separated(
        padding: const EdgeInsets.all(16),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<MovieModel>(
          itemBuilder: (context, item, index) => ItemWidget(
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
