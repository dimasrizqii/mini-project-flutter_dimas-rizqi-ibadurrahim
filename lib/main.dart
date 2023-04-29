// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:mini_project/providers/detail_movie_provider.dart';
import 'package:mini_project/providers/popular_movie_provider.dart';
import 'package:provider/provider.dart';
import 'package:mini_project/pages/list_movie_page.dart';
import 'package:mini_project/providers/discover_movie_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DiscoverMovieProvider>(
          create: (_) => DiscoverMovieProvider(),
        ),
        ChangeNotifierProvider<DetailMovieProvider>(
          create: (_) => DetailMovieProvider(),
        ),
        ChangeNotifierProvider<PopularMovieProvider>(
          create: (_) => PopularMovieProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Project TMDB',
      theme: ThemeData(brightness: Brightness.dark),
      home: const ListMoviePage(),
    );
  }
}
