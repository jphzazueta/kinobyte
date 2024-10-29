import 'package:flutter/material.dart';
import 'package:kino_byte/pages/home.dart';
import 'package:kino_byte/pages/movie.dart';
import 'package:kino_byte/pages/search.dart';
import 'package:flutter/services.dart';

void main() {  
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value)=>
    runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        // '/': (context) => Loading(),
        '/': (context) => const Home(),
        '/search': (context) => const SearchPage(),
        '/movie': (context) => const Movie(),
      }
    ))
  );
  // runApp(MaterialApp(
  //   initialRoute: '/',
  //   routes: {
  //     // '/': (context) => Loading(),
  //     '/': (context) => const Home(),
  //     '/search': (context) => const SearchPage(),
  //     '/movie': (context) => const Movie(),
  //   }
  // ));
}
