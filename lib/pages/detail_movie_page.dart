import 'package:flutter/material.dart';
import 'package:mini_project/di/injection.dart';
import 'package:mini_project/providers/detail_movie_provider.dart';
import 'package:mini_project/widgets/detail_item_movie_widget.dart';
import 'package:provider/provider.dart';

class DetailMoviePage extends StatelessWidget {
  const DetailMoviePage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<DetailMovieProvider>()..getDetail(context, id: id),
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
  double? get expandedHeight => 450;

  @override
  Widget? get flexibleSpace => Consumer<DetailMovieProvider>(
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

class _DetailMovieBoxWidget extends SliverToBoxAdapter {}