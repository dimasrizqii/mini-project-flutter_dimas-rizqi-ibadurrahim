import 'package:flutter/material.dart';
import 'package:mini_project/constant/tmdb_api_constant.dart';
import 'package:mini_project/models/tmdb_responses/detail_movie_response_model.dart';

class DetailItemMovieWidget extends Container {
  final DetailMovieResponseModel detailMovie;

  final double height;
  final double width;

  DetailItemMovieWidget({
    super.key,
    required this.detailMovie,
    required this.height,
    required this.width,
  });

  @override
  Widget? get child => Stack(
        children: [
          Image.network(
            "$imageOriginalUrl${detailMovie.posterPath}",
            height: height,
            width: width,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return SizedBox(
                height: height,
                width: width,
                child: const Icon(
                  Icons.broken_image_outlined,
                ),
              );
            },
          ),
          Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                Colors.black87,
              ],
            )),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detailMovie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      detailMovie.popularity.ceil().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.date_range,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      detailMovie.releaseDate.toString().split(" ").first,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}
