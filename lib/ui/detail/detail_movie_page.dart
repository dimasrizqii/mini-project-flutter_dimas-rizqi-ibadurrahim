import 'package:flutter/material.dart';
import 'package:mini_project/di/injection.dart';
import 'package:mini_project/ui/detail/detail_movie_view_model.dart';
import 'package:mini_project/ui/detail/detail_item_movie_widget.dart';
import 'package:provider/provider.dart';

class DetailMoviePage extends StatelessWidget {
  const DetailMoviePage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<DetailMovieViewModel>()..getDetail(context, id: id),
      builder: (_, __) => Scaffold(
        body: CustomScrollView(
          slivers: [
            _DetailMovieAppBarWidget(context),
            _DetailMovieBoxWidget(),
          ],
        ),
      ),
    );
  }
}

class _DetailMovieAppBarWidget extends SliverAppBar {
  final BuildContext context;

  const _DetailMovieAppBarWidget(this.context);

  @override
  double? get expandedHeight => 480;

  @override
  Widget? get flexibleSpace => Consumer<DetailMovieViewModel>(
        builder: (_, provider, __) {
          final detailMovie = provider.detailMovies;

          if (detailMovie != null) {
            return DetailItemMovieWidget(
              detailMovie: detailMovie,
              height: double.maxFinite,
              width: double.infinity,
            );
          }

          return const CircularProgressIndicator();
        },
      );
}

class _DetailMovieBoxWidget extends SliverToBoxAdapter {
  @override
  Widget? get child => Consumer<DetailMovieViewModel>(
        builder: (_, provider, __) {
          final detailMovie = provider.detailMovies;

          if (detailMovie != null) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Overview",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    detailMovie.overview,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            );
          }

          return Container();
        },
      );
}
