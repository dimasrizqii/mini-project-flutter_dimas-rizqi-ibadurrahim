import 'package:flutter/material.dart';
import 'package:mini_project/di/injection.dart';
import 'package:mini_project/ui/auth/auth_view_model.dart';
import 'package:mini_project/ui/favorites/favorites_view_model.dart';
import 'package:mini_project/ui/detail/detail_movie_view_model.dart';
import 'package:mini_project/ui/detail/detail_item_movie_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class DetailMoviePage extends StatelessWidget {
  const DetailMoviePage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              getIt<DetailMovieViewModel>()..getDetail(context, id: id),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<FavoritesViewModel>(),
        ),
      ],
      builder: (_, __) => Scaffold(
        body: CustomScrollView(
          slivers: [
            _DetailMovieAppBarWidget(context, id),
            _DetailMovieBoxWidget(),
          ],
        ),
      ),
    );
  }
}

class _DetailMovieAppBarWidget extends SliverAppBar {
  final BuildContext context;
  final int movieId;

  const _DetailMovieAppBarWidget(this.context, this.movieId);

  @override
  double? get expandedHeight => 480;

  @override
  List<Widget>? get actions => [
        // Favorite Button
        _FavoriteButton(movieId: movieId),
        // Share Button
        Consumer<DetailMovieViewModel>(
          builder: (_, provider, __) {
            final detailMovie = provider.detailMovies;
            if (detailMovie != null) {
              return IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  Share.share(
                    '${detailMovie.title}\n\n${detailMovie.overview}\n\nRating: ${detailMovie.voteAverage}/10',
                    subject: detailMovie.title,
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ];

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

          return const Center(child: CircularProgressIndicator());
        },
      );
}

// Stateful Favorite Button Widget
class _FavoriteButton extends StatefulWidget {
  final int movieId;

  const _FavoriteButton({required this.movieId});

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool? _isFavorite;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final authViewModel = context.read<AuthViewModel>();
    final favoritesViewModel = context.read<FavoritesViewModel>();

    if (authViewModel.currentUser != null) {
      final isFav = await favoritesViewModel.isFavorite(
        userId: authViewModel.currentUser!.uid,
        movieId: widget.movieId,
      );

      if (mounted) {
        setState(() {
          _isFavorite = isFav;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final authViewModel = context.read<AuthViewModel>();
    final favoritesViewModel = context.read<FavoritesViewModel>();
    final detailViewModel = context.read<DetailMovieViewModel>();

    final user = authViewModel.currentUser;
    final movie = detailViewModel.detailMovies;

    if (user == null || movie == null) return;

    final isNowFavorite = await favoritesViewModel.toggleFavorite(
      userId: user.uid,
      movieId: widget.movieId,
      title: movie.title,
      posterPath: movie.posterPath,
      voteAverage: movie.voteAverage,
    );

    if (mounted) {
      setState(() {
        _isFavorite = isNowFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isNowFavorite ? 'Added to favorites' : 'Removed from favorites',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return IconButton(
      icon: Icon(
        _isFavorite == true ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite == true ? Colors.red : null,
      ),
      onPressed: _toggleFavorite,
    );
  }
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
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Genres",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: detailMovie.genres.map((genre) {
                      return Chip(
                        label: Text(genre.name),
                        backgroundColor: Colors.white24,
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }

          return Container();
        },
      );
}
