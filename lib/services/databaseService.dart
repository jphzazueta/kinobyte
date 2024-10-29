import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kino_byte/helpers/enums.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  
  static const String _watchedMoviesTableName = 'watched_movies';
  static const String _watchedMoviesIdColumnName = 'id';
  static const String _watchedMoviesTitleColumnName = 'movie_title';
  static const String _watchedMoviesYearColumnName = 'year';
  static const String _watchedMoviesRuntimeColumnName = 'runtime';
  static const String _watchedMoviesMovieDbIdColumnName = 'movie_db_id';
  static const String _watchedMoviesPosterPathColumnName = 'poster_path';

  static const String _visualizationsTableName = 'visualizations';
  static const String _visualizationsIdColumnName = 'id';
  static const String _visualizationsMovieIdColumnName = 'movie_id';
  static const String _visualizationsDatetimeWatchedColumnName = 'datetime_watched';
  static const String _visualizationsYearWatchedColumnName = 'year_watched';
  static const String _visualizationsMonthWatchedColumnName = 'month_watched';
  static const String _visualizationsScreenTypeColumnName = 'screen_type';
  static const String _visualizationsPlatformColumnName = 'platform';
  static const String _visualizationsLocationColumnName = 'location';
  static const String _visualizationsAudioLanguageColumnName = 'audio_language';
  static const String _visualizationsSubstitlesLanguageColumnName = 'subtitles_language';

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  static void _createDatabase(Database db) {
    db.execute('''
        CREATE TABLE $_watchedMoviesTableName (
          $_watchedMoviesIdColumnName INTEGER PRIMARY KEY,
          $_watchedMoviesTitleColumnName TEXT NOT NULL,
          $_watchedMoviesYearColumnName INTEGER NOT NULL,
          $_watchedMoviesRuntimeColumnName INTEGER NOT NULL,
          $_watchedMoviesMovieDbIdColumnName INTEGER UNIQUE NOT NULL,
          $_watchedMoviesPosterPathColumnName TEXT
        )
        ''');
        db.execute('''
          CREATE TABLE $_visualizationsTableName (
            $_visualizationsIdColumnName INTEGER PRIMARY KEY,
            $_visualizationsMovieIdColumnName INTEGER NOT NULL,
            $_visualizationsDatetimeWatchedColumnName INTEGER NOT NULL,
            $_visualizationsYearWatchedColumnName INTEGER NOT NULL,
            $_visualizationsMonthWatchedColumnName INTEGER NOT NULL,
            $_visualizationsScreenTypeColumnName TEXT,
            $_visualizationsPlatformColumnName TEXT,
            $_visualizationsLocationColumnName TEXT,
            $_visualizationsAudioLanguageColumnName TEXT,
            $_visualizationsSubstitlesLanguageColumnName TEXT, 
            UNIQUE(
            $_visualizationsMovieIdColumnName, 
            $_visualizationsDatetimeWatchedColumnName
            )
          )
        ''');
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'watched_movies_db.db');
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        print('DATABASE ONCREATE ACTIVATED');
        _createDatabase(db);
      },
      onOpen: (db) {
        print('DATABASE ONOPEN ACTIVADED');
      },
    );
    return database;
  }

  Future<List<Map<String, dynamic>>> get getMoviesWatched async{
    final db = await database;
    dynamic movies = await db.rawQuery(
      '''SELECT 
      $_watchedMoviesTableName.$_watchedMoviesIdColumnName AS movie_id, 
      $_watchedMoviesTableName.$_watchedMoviesMovieDbIdColumnName as movie_db_id, 
      $_visualizationsTableName.$_visualizationsIdColumnName AS vis_id,
      $_watchedMoviesTableName.$_watchedMoviesTitleColumnName AS movie_title,
      $_watchedMoviesTableName.$_watchedMoviesYearColumnName AS year,
      $_visualizationsTableName.$_visualizationsDatetimeWatchedColumnName AS datetime_watched,
      $_visualizationsTableName.$_visualizationsPlatformColumnName AS platform,
      $_visualizationsTableName.$_visualizationsLocationColumnName AS location,
      $_visualizationsTableName.$_visualizationsScreenTypeColumnName AS screen_type,
      $_visualizationsTableName.$_visualizationsAudioLanguageColumnName AS audio_language,
      $_visualizationsTableName.$_visualizationsSubstitlesLanguageColumnName AS subtitles_language,
      $_watchedMoviesTableName.$_watchedMoviesPosterPathColumnName AS poster_path
      FROM $_watchedMoviesTableName JOIN $_visualizationsTableName
      ON $_visualizationsTableName.$_visualizationsMovieIdColumnName 
      = $_watchedMoviesTableName.$_watchedMoviesIdColumnName
      ORDER BY $_visualizationsTableName.$_visualizationsDatetimeWatchedColumnName DESC
      '''
      );
    // print(movies);
    print('=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+');
    return movies;
  }

  Future<Map<String, dynamic>> get getStats async {
    final db = await database;
    Map<String, dynamic> stats = {};

    List<Map<String, dynamic>> movieStats = await db.rawQuery(
      '''SELECT 
      COUNT(*) AS number_movies, 
      COUNT(DISTINCT $_visualizationsMovieIdColumnName) AS number_unique_movies,
      SUM($_watchedMoviesTableName.$_watchedMoviesRuntimeColumnName) AS total_runtime
      FROM $_watchedMoviesTableName JOIN $_visualizationsTableName
      ON $_watchedMoviesTableName.$_watchedMoviesIdColumnName
      = $_visualizationsTableName.$_visualizationsMovieIdColumnName
      '''
    );

    // print(movieStats);

    movieStats[0].forEach((key, value) => stats[key] = value);

    List<Map<String, dynamic>> topMovies = await db.rawQuery(
      '''
      SELECT 
      $_watchedMoviesTableName.$_watchedMoviesTitleColumnName AS movie_title, 
      $_watchedMoviesTableName.$_watchedMoviesRuntimeColumnName AS runtime, 
      $_watchedMoviesTableName.$_watchedMoviesYearColumnName AS year, 
      COUNT(*) AS times_watched  
      FROM $_watchedMoviesTableName JOIN $_visualizationsTableName 
      ON $_watchedMoviesTableName.$_watchedMoviesIdColumnName 
      = $_visualizationsTableName.$_visualizationsMovieIdColumnName 
      GROUP BY movie_title 
      ORDER BY times_watched DESC, runtime DESC 
      LIMIT 10 
      '''
    );

    stats['top_movies'] = [topMovies][0];

    List<Map<String, dynamic>> moviesPerYear = await db.rawQuery(
      '''
      SELECT 
      COUNT($_visualizationsIdColumnName) as movies_watched, 
      $_visualizationsYearWatchedColumnName 
      FROM $_visualizationsTableName 
      GROUP BY $_visualizationsYearWatchedColumnName
      '''
    );

    // List<int> years = List<int>.generate(moviesPerYear[0]['max_year'] - moviesPerYear[0]['min_year'] + 1, (index) => moviesPerYear[0]['min_year'] + index);

    // print(years);

    // stats['years_watched'] = years;

    // print(stats);

    // moviesPerYear.forEach((key, value) => stats[key].add)

    stats['movies_per_year'] = moviesPerYear;

    // insertDataFromJson('movies_watched/movies_watched.json');

    return stats;
  }

  void addVisualization(
    ValueKey speedDialChildKey,
    Map<String, dynamic> movieDetails, 
    Platform? platform, 
    ScreenType? screenType, 
    Location? location,
    MovieLanguage? audioLanguage, 
    MovieLanguage? substitlesLanguage,
    int? selectedDateTime
  ) async {
    final db = await database;
    await db.insert(
      _watchedMoviesTableName,  
      {
        _watchedMoviesTitleColumnName: movieDetails['title'],
        _watchedMoviesYearColumnName: int.parse(movieDetails['release_date'].substring(0,4)),
        _watchedMoviesMovieDbIdColumnName: movieDetails['id'],
        _watchedMoviesPosterPathColumnName: movieDetails['poster_path'],
        _watchedMoviesRuntimeColumnName: movieDetails['runtime'],
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    
    final movieId = await db.query(_watchedMoviesTableName,   // query movie_id from table watched_movies 
          columns: [_watchedMoviesIdColumnName],              // result is a list with a single map, with a single key-value pair
          where: '$_watchedMoviesMovieDbIdColumnName = ?',
          whereArgs: [movieDetails['id'],],
        );
    try{
    await db.insert(
      _visualizationsTableName,
      {
        _visualizationsMovieIdColumnName: movieId[0]['id'],
        _visualizationsDatetimeWatchedColumnName: selectedDateTime,
        _visualizationsYearWatchedColumnName: DateTime.fromMillisecondsSinceEpoch(selectedDateTime!).year,
        _visualizationsMonthWatchedColumnName: DateTime.fromMillisecondsSinceEpoch(selectedDateTime).month,
        _visualizationsPlatformColumnName: platform?.label,
        _visualizationsScreenTypeColumnName: screenType?.label,
        _visualizationsLocationColumnName: location?.label,
        _visualizationsAudioLanguageColumnName: audioLanguage?.label,
        _visualizationsSubstitlesLanguageColumnName: substitlesLanguage?.label,
      }
    );
    } catch (e){
      print(e);
    }

    // final data = await db.query(_watchedMoviesTableName);
    // final visData = await db.query(_visualizationsTableName);
    // print(data);
    // print(visData);
  }

  void removeVisualization(int movieId, int visualizationId) async {
    final db = await database;
    await db.delete(_visualizationsTableName,
      where: '$_visualizationsIdColumnName = ?',
      whereArgs: [visualizationId]
    );

    final numVisList = await db.query(_visualizationsTableName,
      columns: ['COUNT(*) as num_vis'],
      where: '$_visualizationsMovieIdColumnName = ?',
      whereArgs: [movieId]
    );
    print('NUMBER OF VISUALIZATIONS: ${numVisList[0]['num_vis']}');

    if (numVisList[0]['num_vis'] == 0) {
      await db.delete(_watchedMoviesTableName,
        where: '$_watchedMoviesIdColumnName = ?',
        whereArgs: [movieId]
      );
    }
  }
  
  final String apiKey = '1befb2ea0a11e04930e86426dbfc01c1';
  final String apiUrl = 'https://api.themoviedb.org/3';

  Future<Map<String, dynamic>> fetchMovieWithId(int movieId) async {
    final urlMovie = Uri.parse('$apiUrl/movie/${movieId.toString()}?api_key=$apiKey&language=en-US');
    final response = await http.get(urlMovie);

    if (response.statusCode == 200){
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to load movie');
    }
  }

  // Function used once to import my previous history from movies_watched.json
  Future<void> insertDataFromJson (String jsonPath) async {
    final String response = await rootBundle.loadString(jsonPath);
    final data = await json.decode(response);
    // print('DATA LENGTH = ${data.length}');
    data.forEach((movie) async {
      dynamic dateTimeWatched;
      try{
        dateTimeWatched = DateFormat('yyyy-MM-ddTHH:mm').parse(movie['watchedDate']);
      } on Exception catch (_) {
        dateTimeWatched = DateFormat('yyyy-MM-dd').parse(movie['watchedDate']);
      }
      Map<String, dynamic> movieDetails = await fetchMovieWithId(movie['movie']['tmdbId']);
      if (movie['movie']['name'] == 'Hacksaw Ridge') print(movie['movie']['name']);
      addVisualization(
        const ValueKey('another_time'), 
        movieDetails, 
        stringToPlatform(movie['videoSource']), 
        stringToScreenType(movie['screenType']), 
        null, 
        stringToMovieLanguage(movie['audioLocale']), 
        stringToMovieLanguage(movie['subtitleLocale']), 
        dateTimeWatched.millisecondsSinceEpoch
      );
    });
  }
  
}