import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mini_project/models/tmdb_responses/movie_response_model.dart';
import 'package:mini_project/ui/detail/detail_movie_page.dart';
import 'package:mini_project/ui/search/search_movie_view_model.dart';
import 'package:mini_project/widgets/item_movie_widget.dart';
import 'package:provider/provider.dart';

class SearchMoviePage extends StatefulWidget {
  const SearchMoviePage({super.key});

  @override
  State<SearchMoviePage> createState() => _SearchMoviePageState();
}

class _SearchMoviePageState extends State<SearchMoviePage> {
  final TextEditingController _searchController = TextEditingController();
  final PagingController<int, MovieModel> _pagingController = PagingController(
    firstPageKey: 1,
  );

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      final query = context.read<SearchMovieViewModel>().currentQuery;
      if (query.isNotEmpty) {
        context.read<SearchMovieViewModel>().searchMoviesWithPagination(
              context,
              pagingController: _pagingController,
              page: pageKey,
              query: query,
            );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<SearchMovieViewModel>().searchMovies(context, query: query);
    if (query.isNotEmpty) {
      _pagingController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white60),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _onSearchChanged,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              context.read<SearchMovieViewModel>().clearSearch();
            },
          ),
        ],
      ),
      body: Consumer<SearchMovieViewModel>(
        builder: (_, viewModel, __) {
          // Show empty state when no query
          if (viewModel.currentQuery.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.white38),
                  SizedBox(height: 16),
                  Text(
                    'Search for movies',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            );
          }

          // Show loading
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Show error
          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Show search results
          if (viewModel.searchResults.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_outlined, size: 64, color: Colors.white38),
                  SizedBox(height: 16),
                  Text(
                    'No movies found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            );
          }

          return PagedListView.separated(
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
                      builder: (_) => DetailMoviePage(id: item.id),
                    ),
                  );
                },
              ),
              firstPageErrorIndicatorBuilder: (_) => const Center(
                child: Text('Error loading search results'),
              ),
              newPageErrorIndicatorBuilder: (_) => const Center(
                child: Text('Error loading more results'),
              ),
              noItemsFoundIndicatorBuilder: (_) => const Center(
                child: Text('No movies found'),
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          );
        },
      ),
    );
  }
}
