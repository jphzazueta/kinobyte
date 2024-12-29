import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kino_byte/services/databaseService.dart';
import 'package:intl/intl.dart';
import 'package:kino_byte/helpers/info_field.dart';
import 'package:kino_byte/helpers/bottom_navbar.dart';
import 'package:kino_byte/pages/stats_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final DatabaseService _databaseService = DatabaseService.instance;

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('My Watched Movies',
                             style: TextStyle(
                              color: Colors.white,
                                fontWeight: FontWeight.bold,));

  String textInput = '';

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

  void _onTabTapped(int index){
    setState(() {
      _currentPageIndex = index;
    });
  }

  int _currentPageIndex = 0;
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
            bottomNavigationBar: BottomNavbar(
              onTabTapped: _onTabTapped,
              currentPageIndex: _currentPageIndex,
            ),
            body: IndexedStack(
              index: _currentPageIndex,
              children: [
                ListView.builder(
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    return Padding(
                      // key: ValueKey(watchedMoviesList![index]['id']),
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(   // to add a function when tapping each tile/element
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            '/movie',
                            arguments: {
                              'movie_id': watchedMoviesList[index]['movie_db_id'],
                              'title': watchedMoviesList[index]['movie_title'],
                            }
                          );
                        },
                        borderRadius: BorderRadius.circular(20), // matching radius to container so splash is not visible
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
                                    ? Image.network('https://image.tmdb.org/t/p/w200${watchedMoviesList[index]['poster_path']}')
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
                                            fontSize: 20.0,
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
                                        fieldName: 'Audio lang', 
                                        fieldData: '${watchedMoviesList[index]['audio_language'] ?? 'n/a'}',
                                      ),
                                      InfoField(
                                        fieldName: 'Subtitles lang', 
                                        fieldData: '${watchedMoviesList[index]['subtitles_language'] ?? 'n/a'}',
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const StatsPage(),    // second page in nav bar
              ]         
            )
          );
        }
      }
    );
  }
}