import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kino_byte/services/databaseService.dart';
import 'package:intl/intl.dart';
import 'package:kino_byte/helpers/info_field.dart';

// class MovieInfo {
//   String title;
//   String dateTimeWatched;
//   dynamic year;
//   String platform;
//   String place;
//   String screenType;
//   String imageUrl;

//   MovieInfo({required this.title, this.dateTimeWatched = "N/A", required this.year, 
//               this.platform = "N/A", this.place = "N/A", this.screenType = "N/A", 
//              required this.imageUrl});

//   factory MovieInfo.fromJson(Map<String, dynamic> json) {
//     return MovieInfo(
//       title: json['title'],
//       year: json['release_date'],
//       // imageUrl: json['poster_path']
//       imageUrl: json['poster_path'] ?? '/865DntZzOdX6rLMd405R0nFkLmL.jpg'
//     );
//   }
// }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final DatabaseService _databaseService = DatabaseService.instance;
  
  // List<MovieInfo> movies_watched = [
  //   MovieInfo(title: 'Before Sunset', dateTimeWatched: '29.08.2024', year: 2004, platform: 'digital copy', place: 'home', screenType: 'laptop', imageUrl: 'https://m.media-amazon.com/images/M/MV5BMTQ1MjAwNTM5Ml5BMl5BanBnXkFtZTYwNDM0MTc3._V1_.jpg'),
  //   MovieInfo(title: 'Before Sunrise', dateTimeWatched: '26.07.2024', year: 1995, platform: 'digital copy', place: 'home', screenType: 'laptop', imageUrl: 'https://m.media-amazon.com/images/M/MV5BZDdiZTAwYzAtMDI3Ni00OTRjLTkzN2UtMGE3MDMyZmU4NTU4XkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_.jpg'),
  //   MovieInfo(title: 'Furiosa', dateTimeWatched: '04.06.2024', year: 2024, platform: 'cinema', place: 'cinema', screenType: 'projector', imageUrl: 'https://m.media-amazon.com/images/M/MV5BNTcwYWE1NTYtOWNiYy00NzY3LWIwY2MtNjJmZDkxNDNmOWE1XkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg'),
  //   MovieInfo(title: 'The Nice Guys', dateTimeWatched: '31.05.2024', year: 2016, platform: 'Netflix', place: 'home', screenType: 'laptop', imageUrl: 'https://m.media-amazon.com/images/M/MV5BODNlNmU4MGItMzQwZi00NGQyLWEyZWItYjFkNmI0NWI4NjBhXkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_FMjpg_UX1000_.jpg'),
  //   MovieInfo(title: 'The Apartment', dateTimeWatched: '30.04.2024', year: 1960, platform: 'Prime Video', place: 'home', screenType: 'laptop', imageUrl: 'https://m.media-amazon.com/images/M/MV5BNzkwODFjNzItMmMwNi00MTU5LWE2MzktM2M4ZDczZGM1MmViXkEyXkFqcGdeQXVyNDY2MTk1ODk@._V1_FMjpg_UX1000_.jpg'),
  //   MovieInfo(title: 'Glass Onion: A Knives Out Mystery', dateTimeWatched: '26.03.2024', year: 2022, platform: 'Netflix', place: 'home', screenType: 'laptop', imageUrl: 'https://m.media-amazon.com/images/M/MV5BMWYxMWJlNGQtMjQ0OC00ZTRlLWJhMGEtMDUyZTVlZTQ0NzI2XkEyXkFqcGdeQXVyNzYyOTM1ODI@._V1_QL75_UX190_CR0,0,190,281_.jpg'),
  //   MovieInfo(title: 'Nimona', dateTimeWatched: '24.03.2024', year: 2023, platform: 'Netflix', place: 'home', screenType: 'laptop', imageUrl: 'https://m.media-amazon.com/images/M/MV5BYTI3MzZhODctYjc5MC00NWIxLWFlMjAtZjlmMjBkZjYwZDFhXkEyXkFqcGc@._V1_.jpg'),
  // ];

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('My Watched Movies',
                             style: TextStyle(
                              color: Colors.white,
                                fontWeight: FontWeight.bold,));

  String textInput = '';
  // final String apiKey = '1befb2ea0a11e04930e86426dbfc01c1';
  // final String apiUrl = 'https://api.themoviedb.org/3/search/movie';

  // Future<List<MovieInfo>> fetchMovies(String textInput) async {
  //   String encodedInput = Uri.encodeQueryComponent(textInput);
  //   final url = Uri.parse('$apiUrl?query=$encodedInput&api_key=$apiKey&language=en-US&page=1');
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(response.body);
  //     // print(jsonResponse);
  //     final List movies = jsonResponse['results'];

  //     // Convert each item in the list to a Movie object
  //     return movies.map((movie) => MovieInfo.fromJson(movie)).toList();
  //   } else {
  //     throw Exception('Failed to load movies');
  //   }
  // }

  late Future<List<Map<String, dynamic>>> _watchedMoviesFuture;
  @override
  void initState() {
    super.initState();
    _watchedMoviesFuture = _databaseService.getMoviesWatched;
  }

  void _refreshMoviesList() {
    setState(() {
      _watchedMoviesFuture = _databaseService.getMoviesWatched;
    });
  }

  double dataFontSize = 14.0;
  Color dataFontColor = Colors.grey[300]!;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _watchedMoviesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError){
          return const Scaffold(
            body: Center(
              child: Text('THERE IS AN ERROR',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),),
            )
          );
        }

        final watchedMoviesList = snapshot.data;
        int itemCount = watchedMoviesList?.length ?? 0;

        if (itemCount == 0){
          return Scaffold(
            backgroundColor: const Color(0xFF06062B),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 113, 23, 146),
              title:  Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                child: customSearchBar,
              ),
              actions: [
                IconButton(
                  color: Colors.white,
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/search');
                    _refreshMoviesList();
                  },
                  icon: customIcon,
                )
              ]
            ),
            body: const Center(
              child: Text('May the films be with you... eventually.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 3,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'NewsGothic',
                   
            ))),
          );
        }
        else{
          return Scaffold(
            backgroundColor: const Color(0xFF06062B),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 113, 23, 146),
              title:  Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                child: customSearchBar,
              ),
              actions: [
                IconButton(
                  color: Colors.white,
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/search');
                    _refreshMoviesList();
                  },
                  icon: customIcon,
                )
              ]
            ),
            body: ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return Padding(
                  // key: ValueKey(watchedMoviesList![index]['id']),
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 23, 23, 70),
                    ),
          
                    child: Slidable(
                      endActionPane: ActionPane(
                    motion: const DrawerMotion(), 
                    children: [
                      SlidableAction(
                        icon: Icons.delete,
                        backgroundColor: Colors.red,
                        onPressed: ((context) {
                          // print('---------------- MOVIE DELETED -------------------');
                          // print('MOVIE ID: ${watchedMoviesList![index]['movie_id']} ${watchedMoviesList[index]['movie_id'].runtimeType}');
                          // print('VISUALIZATION ID: ${watchedMoviesList[index]['vis_id']} ${watchedMoviesList[index]['vis_id'].runtimeType}');
                          _databaseService.removeVisualization(watchedMoviesList![index]['movie_id'], watchedMoviesList[index]['vis_id']);
                          _refreshMoviesList();
                        })
                      )
                    ]
                  ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10.0),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: (watchedMoviesList![index]['poster_path'] != null) 
                              ? Image.network('https://image.tmdb.org/t/p/w200${watchedMoviesList![index]['poster_path']}')
                              : Image.asset('assets/poster_placeholder.png'),
                            )
                            ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            flex: 9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Text('${watchedMoviesList[index]['movie_title']} (${watchedMoviesList[index]['year']})',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      height: 0.0,
                                    )),
                                ),
                                InfoField(
                                  fieldName: 'Watched', 
                                  fieldData: DateFormat('dd.MM.yyyy - kk:mm')
                                    .format(DateTime
                                    .fromMillisecondsSinceEpoch(watchedMoviesList[index]['datetime_watched']))
                                    .toString()
                                ),
                                InfoField(
                                  fieldName: 'Platform', 
                                  fieldData: '${watchedMoviesList[index]['platform'] ?? 'n/a'}',
                                ),
                                InfoField(
                                  fieldName: 'Location',
                                  fieldData: '${watchedMoviesList[index]['location'] ?? 'n/a'}',
                                ),
                                InfoField(
                                  fieldName: 'Screen type', 
                                  fieldData: '${watchedMoviesList[index]['screen_type'] ?? 'n/a'}',
                                ),
                                InfoField(
                                  fieldName: 'Audio Lang', 
                                  fieldData: '${watchedMoviesList[index]['audio_language'] ?? 'n/a'}',
                                ),
                                InfoField(
                                  fieldName: 'Subtitles Lang', 
                                  fieldData: '${watchedMoviesList[index]['subtitles_language'] ?? 'n/a'}',
                                ),
                                // Text('Watched: ${DateFormat('dd.MM.yyyy - kk:mm').format(DateTime.fromMillisecondsSinceEpoch(watchedMoviesList[index]['datetime_watched']))}',
                                //   style: TextStyle(
                                //     color: dataFontColor,
                                //     fontSize: dataFontSize,
                                // )),
                                // Text('Platform: ${watchedMoviesList[index]['platform'] ?? 'n/a'}',
                                //   style: TextStyle(
                                //     color: dataFontColor,
                                //     fontSize: dataFontSize,
                                // )),
                                // Text('Location: ${watchedMoviesList[index]['location'] ?? 'n/a'}',
                                //     style: TextStyle(
                                //       color: dataFontColor,
                                //       fontSize: dataFontSize,
                                //   )),
                                // Text('Screen type: ${watchedMoviesList[index]['screen_type'] ?? 'n/a'}',
                                //   style: TextStyle(
                                //     color: dataFontColor,
                                //     fontSize: dataFontSize,
                                // )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          
            // body: ListView.builder(
            //   itemCount: movies_watched.length,
            //   itemBuilder: (context, index) {
            //     return Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Container(
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(20),
            //           color: const Color.fromARGB(255, 23, 23, 70),
            //         ),
          
            //         child: Row(
            //           children: [
            //             const SizedBox(width: 10.0),
            //             Expanded(
            //               flex: 3,
            //               child: Padding(
            //                 padding: const EdgeInsets.all(5.0),
            //                 child: Image.network(movies_watched[index].imageUrl),
            //               )
            //               ),
            //             const SizedBox(width: 20.0),
            //             Expanded(
            //               flex: 9,
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text('${movies_watched[index].title} (${movies_watched[index].year})',
            //                     style: const TextStyle(
            //                       color: Colors.white,
            //                       fontSize: 18.0,
            //                     )),
            //                   Padding(
            //                     padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            //                     child: Text('Watched: ${movies_watched[index].dateTimeWatched}',
            //                       style: TextStyle(
            //                         color: dataFontColor,
            //                         fontSize: dataFontSize,
            //                       )),
            //                   ),
            //                   Text('Platform: ${movies_watched[index].platform}',
            //                     style: TextStyle(
            //                       color: dataFontColor,
            //                       fontSize: dataFontSize,
            //                     )),
            //                   Text('Place: ${movies_watched[index].place}',
            //                       style: TextStyle(
            //                         color: dataFontColor,
            //                         fontSize: dataFontSize,
            //                       )),
            //                   Text('Screen: ${movies_watched[index].screenType}',
            //                       style: TextStyle(
            //                         color: dataFontColor,
            //                         fontSize: dataFontSize,
            //                       )),
            //                 ],
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     );
            //   },
            // )
          );
        }
      }
    );
  }
}
