import 'package:flutter/material.dart';
import 'package:mini_project/constant/tmdb_api_constant.dart';

enum TypeSrcImg { movieDb, external }

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    this.imageSrc,
    this.type = TypeSrcImg.movieDb,
    this.height,
    this.width,
    this.onTap,
    this.radius = 0.0,
  });

  final String? imageSrc;
  final TypeSrcImg type;
  final double? height;
  final double? width;
  final double radius;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.network(
            type == TypeSrcImg.movieDb
                ? '$imageW500Url$imageSrc'
                : imageSrc!,
            height: height,
            width: width,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              return Container(
                height: height,
                width: width,
                color: Colors.black26,
                child: child,
              );
            },
            errorBuilder: (_, __, ___) {
              return SizedBox(
                height: height,
                width: width,
                child: const Icon(
                  Icons.broken_image_rounded,
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}