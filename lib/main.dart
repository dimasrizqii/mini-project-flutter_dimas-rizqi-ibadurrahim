import 'package:flutter/material.dart';
import 'package:mini_project/di/injection.dart';
import 'package:mini_project/ui/home/list_movie_page.dart';
import 'package:mini_project/ui/detail/detail_movie_view_model.dart';
import 'package:mini_project/ui/discover/discover_movie_view_model.dart';
import 'package:mini_project/ui/top_rated/top_rated_movie_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  setup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => getIt<DiscoverMovieViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<TopRatedMovieViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<DetailMovieViewModel>(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(brightness: Brightness.dark),
        debugShowCheckedModeBanner: false,
        home: const ListMoviePage(),
      ),
    );
  }
}
