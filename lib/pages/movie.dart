import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kino_byte/helpers/custom_alert_dialog.dart';
// import 'package:kino_byte/movie_info.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:kino_byte/helpers/enums.dart';
import 'package:kino_byte/services/databaseService.dart';
// import 'package:kino_byte/helpers/custom_drop_down_menu.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Movie extends StatefulWidget {
  const Movie({super.key});

  @override
  State<Movie> createState() => _MovieState();
}

class MovieScaffold extends StatelessWidget {

  final Map<String, dynamic> movieData;
  final Widget? body;
  final Widget? floatingActionButton;

  const MovieScaffold({
    super.key,
    required this.movieData,
    required this.body,
    this.floatingActionButton,
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06062B),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 113, 23, 146),
        title: Text(
          movieData['title'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () => Navigator.pop(context, true),
        ),
          // onPressed: () => setState(() {}),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

class _MovieState extends State<Movie> {
  final DatabaseService _databaseService = DatabaseService.instance;

  ScreenType? selectedScreenType;
  Platform? selectedPlatform;
  Location? selectedLocation;
  MovieLanguage? selectedAudioLanguage;
  MovieLanguage? selectedSubstitlesLanguage;

  final String apiKey = '1befb2ea0a11e04930e86426dbfc01c1';
  final String apiUrl = 'https://api.themoviedb.org/3';

  Future<List<Map<String, dynamic>>> fetchMovieWithId(int movieId) async {
    final urlMovie = Uri.parse('$apiUrl/movie/${movieId.toString()}?api_key=$apiKey&language=en-US');
    final response = await http.get(urlMovie);

    // final urlCast = Uri.parse('$apiUrl/${movieId.toString()}?api_key=$apiKey&language=en-US');
    final urlCast = Uri.parse('$apiUrl/movie/${movieId.toString()}/credits?api_key=$apiKey&language=en-US');
    final responseCast = await http.get(urlCast);

    if (response.statusCode == 200 && responseCast.statusCode == 200){
      final jsonResponse = json.decode(response.body);
      final jsonResponseCast = json.decode(responseCast.body);
      return [jsonResponse, jsonResponseCast];
    } else {
      throw Exception('Failed to load movie');
    }
  }

  Future<Map<String, dynamic>> fetchPersonWithId(int personId) async {
    final urlMovie = Uri.parse('$apiUrl/person/${personId.toString()}/images?api_key=$apiKey&language=en-US');
    final response = await http.get(urlMovie);

    if (response.statusCode == 200){
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to find person');
    }
  }

  Padding movieField(String fieldName, String fieldData) {   // For displaying field with the name bold and the data normal weight
    return Padding(
      padding: const EdgeInsets.only(bottom:3.0),
      child: RichText(text: 
        TextSpan(
          style: const TextStyle(
            color: Colors.white,
          ),
          children: [
            TextSpan(text: '$fieldName: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
            TextSpan(text: fieldData)])),
    );
  } 

  //  DateTime selectedDate = DateTime.now();
   Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2099)
    );
    return picked;
  }

  // TimeOfDay selectedTime = TimeOfDay.now();
  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now(),
    );
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    // Retrieving the informationo passed from search.dart
    Map<String, dynamic> movieData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchMovieWithId(movieData['movie_id']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return MovieScaffold(
            movieData: movieData, 
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        else if (snapshot.hasError){
          return MovieScaffold(
            movieData: movieData, 
            body: Center(child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                  color: Colors.red
              ))
            ),
          );
        }
        else if (snapshot.hasData){
          final movieDetails = snapshot.data;
          print('THE POSTER PATH IS: ${movieDetails![0]['poster_path']}');
          String directors= movieDetails[1]['crew']    // Get the director(s) of the movie and format it as a String
                            .where((person) => person['job'] == 'Director')
                            .map((person) => person['name'])
                            .toString();
          return MovieScaffold(
            movieData: movieData, 
            floatingActionButton: SpeedDial(
              spaceBetweenChildren: 0.0,
              childPadding: const EdgeInsets.symmetric(vertical: 0),
              childrenButtonSize: const Size(70, 200),
              animatedIcon: AnimatedIcons.add_event,
              animatedIconTheme: const IconThemeData(color: Colors.white,),
              overlayOpacity: 0.0,
              backgroundColor: const Color.fromARGB(255, 113, 23, 146),
              children: [
                SpeedDialChild(
                  label: 'Just started',
                  labelStyle: const TextStyle(fontSize: 18.0),
                  backgroundColor: Colors.blue,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      int selectedDateTime = DateTime.now().millisecondsSinceEpoch;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomAlertDialog(
                          valueKey: const ValueKey('just_started'),
                          databaseService: _databaseService,
                          movieDetails: movieDetails[0], 
                          selectedPlatform: selectedPlatform, 
                          selectedScreenType: selectedScreenType, 
                          selectedLocation: selectedLocation,
                          selectedAudioLanguage: selectedAudioLanguage, 
                          selectedSubstitlesLanguage: selectedSubstitlesLanguage,
                          selectedDateTime: selectedDateTime,
                        ),
                      );
                    });
                  }
                ),
                SpeedDialChild(
                  label: 'Just finished',
                  labelStyle: const TextStyle(fontSize: 18.0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      int selectedDateTime = (DateTime.now().millisecondsSinceEpoch - movieDetails[0]['runtime']*60*1000).toInt();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomAlertDialog(
                          valueKey: const ValueKey('just_finished'),
                          databaseService: _databaseService,
                          movieDetails: movieDetails[0], 
                          selectedPlatform: selectedPlatform, 
                          selectedScreenType: selectedScreenType, 
                          selectedLocation: selectedLocation,
                          selectedAudioLanguage: selectedAudioLanguage, 
                          selectedSubstitlesLanguage: selectedSubstitlesLanguage,
                          selectedDateTime: selectedDateTime,
                        ),
                      );
                    });
                  }
                ),
                SpeedDialChild(
                  label: 'Another time',
                  labelStyle: const TextStyle(fontSize: 18.0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      DateTime? selectedDate = await _selectDate(context);
                      if (selectedDate == null) return;

                      // ignore: use_build_context_synchronously
                      TimeOfDay? selectedTime = await _selectTime(context);
                      print('SELECTED DATE TIME: $selectedDate + $selectedTime');

                      if (selectedTime == null) return;
                      int selectedDateTime = DateTime(
                        selectedDate.year, selectedDate.month, selectedDate.day, 
                        selectedTime.hour, selectedTime.minute).millisecondsSinceEpoch;

                      showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (BuildContext context) => CustomAlertDialog(
                          valueKey: const ValueKey('another_time'),
                          databaseService: _databaseService,
                          movieDetails: movieDetails[0], 
                          selectedPlatform: selectedPlatform, 
                          selectedScreenType: selectedScreenType, 
                          selectedLocation: selectedLocation,
                          selectedAudioLanguage: selectedAudioLanguage, 
                          selectedSubstitlesLanguage: selectedSubstitlesLanguage,
                          selectedDateTime: selectedDateTime,
                        ),
                      );
                    });
                  }
                )
              ]
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(    // Container with movie title and facts
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: const Color.fromARGB(255, 23, 23, 70),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 250.0,
                            child: (movieDetails[0]['poster_path'] != null) ? Image.network(
                              'https://image.tmdb.org/t/p/w500${movieDetails[0]['poster_path']}')
                              : Image.asset('assets/poster_placeholder.png'),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AutoSizeText('${movieDetails[0]['title']}',
                                  presetFontSizes: const [25,20,10],
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    height: 0,
                                  )
                                ),
                                const SizedBox(height: 10.0,),
                                movieField('Release date', DateFormat('dd.MM.yyyy').format(DateTime.parse(movieDetails[0]['release_date']))),
                                movieField('Runtime', '${(movieDetails[0]['runtime']/60).floor()}h ${'${(movieDetails[0]['runtime']%60)}'.padLeft(2,'0')}m' ),
                                movieField('Director', directors.substring(1, directors.length - 1)),
                                movieField('Budget', '\$${NumberFormat('#,###').format(movieDetails[0]['budget'])}'),
                                movieField('Revenue', '\$${NumberFormat('#,###').format(movieDetails[0]['revenue'])}'),
                              ],
                            ),
                          ),
                        ],)
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
                      child: Text('Overview',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          letterSpacing: 1,
                          )),
                    ),
                    // const SizedBox(height: 10.0),
                    Container(    // Box with the overview of the movie
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: const Color.fromARGB(255, 23, 23, 70),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(movieDetails[0]['overview'],
                            style: const TextStyle(
                              color: Colors.white,
                              // fontSize: 13.0,
                            )
                          ),
                        ],
                      )
                    ),
                    const SizedBox(height: 5.0,),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
                      child: Text('Cast (${movieDetails[1]['cast'].length})',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        )),
                    ),
                    const SizedBox(height: 5.0),
                    GridView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,                      
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 240.0,
                      ),
                      itemCount: movieDetails[1]['cast'].length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color.fromARGB(255, 23, 23, 70),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Builder(builder: (context) {
                                dynamic actorImage;
                                
                                movieDetails[1]['cast'][index]['profile_path'] != null
                                  ? actorImage = NetworkImage('https://image.tmdb.org/t/p/w200/${movieDetails[1]['cast'][index]['profile_path']}')
                                  : actorImage = const AssetImage('assets/actor_placeholder.jpg');
    
                                return Expanded(
                                  flex: 9,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: SizedBox(
                                        // height: 120.0,
                                        width: double.infinity,
                                        child: Image(image: actorImage,
                                          fit: BoxFit.cover,),
                                      ),
                                  ),
                                );
                              }),
    
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 3, left: 3),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(movieDetails[1]['cast'][index]['name'],
                                      maxLines: 2,
                                      minFontSize: 13.0,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        height: 0,
                                    )),
                                  ),
                                ),
                              ),
    
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: AutoSizeText(movieDetails[1]['cast'][index]['character'],
                                      maxLines: 2,
                                      maxFontSize: 12.0,
                                      minFontSize: 10.0,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                        height: 0,
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            )
          );
        }
        else {
          return Scaffold(
            backgroundColor: const Color(0xFF06062B),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 113, 23, 146),
              title: Text(
                movieData['title'],
                style: const TextStyle(
                  color: Colors.white,
                  // fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ),
            body: const Center(child: Text('No movie data available')),
          );
        }
      },
    );
  }
}