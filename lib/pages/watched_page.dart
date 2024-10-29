import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kino_byte/services/databaseService.dart';
import 'package:kino_byte/helpers/info_field.dart';
import 'package:intl/intl.dart';

class WatchedPage extends StatefulWidget {
  final int itemCount;
  final List<Map<String, dynamic>> watchedMoviesList;
  
  const WatchedPage({
    super.key,
    required this.itemCount,
    required this.watchedMoviesList,
  });

  @override
  State<WatchedPage> createState() => _WatchedPageState();
}

class _WatchedPageState extends State<WatchedPage> {
  final DatabaseService _databaseService = DatabaseService.instance;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.itemCount,
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
                      _databaseService.removeVisualization(widget.watchedMoviesList[index]['movie_id'], widget.watchedMoviesList[index]['vis_id']);
                      setState(() {
                        _watchedMoviesFuture = _databaseService.getMoviesWatched;
                      });
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
                      child: (widget.watchedMoviesList[index]['poster_path'] != null) 
                      ? Image.network('https://image.tmdb.org/t/p/w200${widget.watchedMoviesList[index]['poster_path']}')
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
                          child: Text('${widget.watchedMoviesList[index]['movie_title']} (${widget.watchedMoviesList[index]['year']})',
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
                            .fromMillisecondsSinceEpoch(widget.watchedMoviesList[index]['datetime_watched']))
                            .toString()
                        ),
                        InfoField(
                          fieldName: 'Platform', 
                          fieldData: '${widget.watchedMoviesList[index]['platform'] ?? 'n/a'}',
                        ),
                        InfoField(
                          fieldName: 'Location',
                          fieldData: '${widget.watchedMoviesList[index]['location'] ?? 'n/a'}',
                        ),
                        InfoField(
                          fieldName: 'Screen type', 
                          fieldData: '${widget.watchedMoviesList[index]['screen_type'] ?? 'n/a'}',
                        ),
                        InfoField(
                          fieldName: 'Audio lang', 
                          fieldData: '${widget.watchedMoviesList[index]['audio_language'] ?? 'n/a'}',
                        ),
                        InfoField(
                          fieldName: 'Subtitles lang', 
                          fieldData: '${widget.watchedMoviesList[index]['subtitles_language'] ?? 'n/a'}',
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}