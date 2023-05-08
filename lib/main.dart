import 'package:flutter/material.dart';
import 'package:mini_project/di/injection.dart';
import 'package:mini_project/pages/list_movie_page.dart';
import 'package:mini_project/providers/detail_movie_provider.dart';
import 'package:mini_project/providers/discover_movie_provider.dart';
import 'package:mini_project/providers/top_rated_movie_provider.dart';
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
          create: (_) => getIt<DiscoverMovieProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<TopRatedMovieProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<DetailMovieProvider>(),
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
