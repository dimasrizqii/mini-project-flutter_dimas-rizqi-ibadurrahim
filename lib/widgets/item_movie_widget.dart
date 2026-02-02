import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mini_project/constant/tmdb_api_constant.dart';
import 'package:mini_project/models/tmdb_responses/movie_response_model.dart';
import 'package:shimmer/shimmer.dart';

class ItemMovieWidget extends Container {
  final MovieModel movie;

  final double height;
  final double width;
  final void Function()? onTap;

  ItemMovieWidget({
    super.key,
    required this.movie,
    required this.height,
    required this.width,
    this.onTap,
  });

  @override
  Clip get clipBehavior => Clip.hardEdge;

  @override
  Decoration? get decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      );

  @override
  Widget? get child => Stack(
        children: [
          CachedNetworkImage(
            imageUrl: "$imageOriginalUrl${movie.backdropPath}",
            height: height,
            width: width,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[850]!,
              highlightColor: Colors.grey[700]!,
              child: Container(
                height: height,
                width: width,
                color: Colors.grey[850],
              ),
            ),
            errorWidget: (context, url, error) {
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
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${movie.voteAverage}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
              ),
            ),
          )
        ],
      );
}
