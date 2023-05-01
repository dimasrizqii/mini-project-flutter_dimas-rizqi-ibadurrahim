import 'package:flutter/material.dart';
import 'package:mini_project/constant/tmdb_api_constant.dart';
import 'package:mini_project/providers/detail_movie_provider.dart';
import 'package:provider/provider.dart';

class DetailMoviePage extends StatefulWidget {
  final int id;
  const DetailMoviePage({super.key, required this.id});

  @override
  State<DetailMoviePage> createState() => _DetailMoviePageState();
}

class _DetailMoviePageState extends State<DetailMoviePage> {
  @override
  void initState() {
    final detailMoviewViewModel =
        Provider.of<DetailMovieProvider>(context, listen: false);
    detailMoviewViewModel.getDetailMovie(widget.id.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final detailMoviewViewModel =
        Provider.of<DetailMovieProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Movie'),
      ),
      body: detailMoviewViewModel.isLoadingDetailMovie
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.network(
                    "$baseUrl/${detailMoviewViewModel.detailMovieResponse.posterPath}",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        detailMoviewViewModel.detailMovieResponse.title ?? ""),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        detailMoviewViewModel.detailMovieResponse.overview ??
                            ""),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      detailMoviewViewModel.detailMovieResponse.originalLanguage
                              ?.toUpperCase() ??
                          "",
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
