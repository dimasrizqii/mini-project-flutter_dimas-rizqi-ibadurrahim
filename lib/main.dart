import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mini_project/firebase_options.dart';
import 'package:mini_project/di/injection.dart';
import 'package:mini_project/ui/auth/auth_view_model.dart';
import 'package:mini_project/ui/auth/login_page.dart';
import 'package:mini_project/ui/home/list_movie_page.dart';
import 'package:mini_project/ui/detail/detail_movie_view_model.dart';
import 'package:mini_project/ui/discover/discover_movie_view_model.dart';
import 'package:mini_project/ui/top_rated/top_rated_movie_view_model.dart';
import 'package:mini_project/ui/search/search_movie_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
          create: (_) => getIt<AuthViewModel>()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<DiscoverMovieViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<TopRatedMovieViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<DetailMovieViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<SearchMovieViewModel>(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(brightness: Brightness.dark),
        debugShowCheckedModeBanner: false,
        home: Consumer<AuthViewModel>(
          builder: (context, authViewModel, _) {
            if (authViewModel.isLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (authViewModel.isAuthenticated) {
              return const ListMoviePage();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
