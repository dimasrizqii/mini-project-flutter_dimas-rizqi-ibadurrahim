import 'package:flutter/material.dart';
import 'package:mini_project/di/injection.dart';
import 'package:mini_project/providers/detail_movie_provider.dart';
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
            Consumer<DetailMovieProvider>(
              builder: (_, provider, __) {
                return SliverAppBar(
                  title: Text(
                      provider.movies == null ? "" : provider.movies!.title),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
