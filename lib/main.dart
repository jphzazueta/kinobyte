import 'package:flutter/material.dart';
import 'package:kino_byte/pages/home.dart';
import 'package:kino_byte/pages/loading.dart';
import 'package:kino_byte/pages/movie.dart';
import 'package:kino_byte/pages/search.dart';

void main() => runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      // '/': (context) => Loading(),
      '/': (context) => const Home(),
      '/search': (context) => const SearchPage(),
      '/movie': (context) => const Movie(),
    }
  ));


