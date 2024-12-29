import 'package:flutter/material.dart';
import 'package:kino_byte/helpers/debouncer.dart';
import 'package:kino_byte/helpers/movie_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  String textInput = '';
  final String apiKey = '1befb2ea0a11e04930e86426dbfc01c1';
  final String apiUrl = 'https://api.themoviedb.org/3/search/movie';

  Future<List<MovieInfo>> fetchMovies(String textInput) async {
    String encodedInput = Uri.encodeQueryComponent(textInput);
    final url = Uri.parse('$apiUrl?query=$encodedInput&api_key=$apiKey&language=en-US&page=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List movies = jsonResponse['results'];

      // Convert each item in the list to a Movie object
      return movies.map((movie) => MovieInfo.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  List<MovieInfo>? movies;
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06062B),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 113, 23, 146),
        title: TextField(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
          decoration: InputDecoration(
            hintText: 'Search movie',
            hintStyle: TextStyle(
              color: Colors.grey[400],
            )
          ),
          onChanged: (query) {
            _debouncer.run(() async {
              movies = await fetchMovies(query);
              setState(() {});
            });
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white,),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: movies == null
      ? const Center(child: CircularProgressIndicator())
      : ListView.builder(
        itemCount: movies?.length ?? 0,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 23, 23, 70),
              ),
              child: ListTile(
                leading: SizedBox(
                  height: 100.0,
                  child: (movies?[index].imageUrl != null)
                    ? Image.network('https://image.tmdb.org/t/p/w200${movies?[index].imageUrl}',fit: BoxFit.fitHeight,)
                    : Image.asset('assets/poster_placeholder.png'),
                ),
                title: Text('${movies![index].title}${movies![index].year.length >= 4   // Display movie title and year if available
                            ? ' (${movies![index].year.substring(0,4)})'
                            : ''}',
                  style: const TextStyle(
                    color: Colors.white,
                  )),
                minTileHeight: 100.0,
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    '/movie',
                    arguments: {
                      'movie_id': movies![index].movieId,
                      'title': movies![index].title,
                      // 'release_date': movies![index].year,
                    }
                  );
                },
              )
            ),
          );
        },
      ),
    );
  }
}

extension on List<MovieInfo>? {
  get imageUrl => null;
}