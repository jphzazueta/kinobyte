# KINOBYTE
#### Video Demo:  https://youtu.be/QK7yinKeLFI
## Description:
Kinobyte is a mobile Android app for tracking watched movies.

![kinobyte](/assets/readme/watched_movies.png)
![kinobyte](/assets/readme/search.png)
![kinobyte](/assets/readme/movie_page_2.png)
![kinobyte](/assets/readme/stats_1.png)
![kinobyte](/assets/readme/stats_2.png)



## Name origin
The origin of the name is a wordplay between the words *Kino* and *Kilobyte*. *Kino* is the German word for cinema (as well as in some other languages such as Polish, Finnish, Czech, etc.), while *Kilobyte* is of course a unit of digital storage of data. Therefore, the name is meant to convey that one is 'storing' or 'saving' in the app the movies he or she watched.

## Motivation
Kinobyte was developed as a response to the discontinuation of the app MoviesFad (RIP 😢), which I used to employ for my personal movie tracking. After it went out of business in late 2023, I looked for suitable alternatives such as Letterboxd, TV Time, and Trakt, but none of them fulfilled my basic requirements: logging information and a stats page.

The first thing that MoviesFad excelled at was having a extensive amount of fields to fill when logging a watched movie, such as:
1. Datetime stamp
2. Place watched
3. Audio language
4. Subtitles language
5. Screen type
6. etc...

The other thing I really liked about MoviesFad was a simple stats page that showed stats such as:
1. Number of movies watched
2. Number of unique movies watched
3. Watched movies rank against other users
4. Most-watched movies
5. Most-watched genres
6. etc...

Despite there being a fee one could pay, it was only to get rid of ads, and the all the features themselves were free of charge, which cannot be said for apps such as Letterboxd.

All of these factors resulted in the perfect opportunity to develop a simple app that could fulfill this basic requirements I had for a movie tracking app.

## Why Flutter?
The app was developed using Flutter. A choice which came down to the following reasons:

### 1. Android user
As an Android user myself, using Swift to write the app was out of the question.

### 2. Native app vs multiplatform
I was then left with the option of choosing between building a native Android app, or use a multiplatform framework such as React Navite and Flutter. I did a little bit of research, and found out that the main reason one builds a native Android app with Kotlin (previously with Java) was performance. Since my app wasn't going to be a game or a very demanding app, I opted for a multiplatform approach, since I liked the option of potentially making the app available for iOS.

### 3. Flutter vs React Native
The most popular options for multiplatform development I found were Flutter and React Native. Both seemed like very good options, but Flutter seemed more intuitive to me, as well as being praised for having good documentation and a growing community. In my head it also made a lot of sense to use a framework developed by Google over Meta when developing an Android app.

## Database source
The app connects to [The Movie DB](https://www.themoviedb.org/) API, and fetches all required information.

## Project Structure
The project files are divided in three main folders: `helpers`, `pages`, and `services`. All of which can be found inside `./lib`

### Helpers

* `barchart.dart` : a simple bar chart class is defined using [fl_chart](https://pub.dev/packages/fl_chart), which gets implemented on `pages/stats_page.dart` for displaying the number of watched movies per year.

* `bottom_navbar.dart` : a custom navbar class is defined, which allows to switch between the list of watched movies and the user stats.

* `custom_alert_dialog.dart` : when adding a watched movie, a pop-up shows up to enter the information such as *screen type, audio language, etc*. A custom pop-up class `CustomAlertDialog` is defined in this file for easier implementation in `pages/movie.dart`

* `custom_drop_down_menu.dart` : the `CustomAlertDialog` class has many drop-down menus with the options for the respective field. The format and aesthetics of these fields is specified through the custom class `AddMovieDropdown` created here.

* `debouncer.dart` : defines a `Debouncer` class used to limit how often the `fetchMovies` function gets called when searching for results. It gets implemented in `pages/search.dart` with a 500ms delay.

* `enums.dart` : a list of enums is defined. Each enum contains the options to display for each data field of the `CustomAlertDialog` inside of an `AddMovieDropdown`instance

* `info_field.dart` : defines the `InfoField` class, which is used to format each data field of a watched movie in the Home page. 

* `movie_info.dart` : defines a `MovieInfo` class used by the `fetchMovies()` function in `search.dart` to fetch the list of movies to display while seaching.

### Pages

* `home.dart` : the main screen for the app gets defined here. If the home screen cannot be loaded, an error message gets displayed. If everything runs as expected but the list of watched movies is empty, the message 'May the films be with you... eventually.' gets displayed. The bottom navbar also doesn't get displayed yet, until there is at least one entry in the list.

    If there are movies to be displayed, a list of tiles containing information about each watched movie gets rendered. Each tile displays the following data:
    - Movie poster
    - Movie title (with release year in parenthesis)
    - Datetime watched
    - Platform (e.g. Netflix, PrimeVideo, DVD, etc.)
    - Location (e.g  Home, Cinema, Friend's house, etc.)
    - Screen type (e.g. TV, Laptop, Proyector, etc.)
    - Audio language
    - Subtitles language

    When tapping a tile, the info page of the movie opens. 

    One can also left swipe a tile. This will show a delete button to delete said tile.

    There's also a search icon on the upper right corner to search for movies to add.


* `movie.dart` : defines the look for the info page of each movie, divided in four components:
    1. **Title and basic info**: display the following basic facts about the movie:

        - Poster
        - Movie title
        - Release date
        - Runtime
        - Director(s)
        - Budget
        - Revenue
    2. **Overview**: shows a brief synopsis of the movie plot

    3. **Cast**: displays the cast members of the movie in a grid, displaying for each member a picture, name, and character's name.
    
    4. **Add to watch list**: a button on the lower right corner with a '+' sign, that opens a floating menu to add a new entry to the list of watched movies. The floating menu consists of three options:

        - Another time: manually enter datetime
        - Just finished: substract runtime from current datetime
        - Just started: use current datetime

* `search.dart` : when tapping on the search button on the home page, a search page opens and one can begin to type a movie name. If no character has been typed, an empty page with a loading animations gets displayed. As soon as a character get typed in by the user, a list of up to twenty suggested movies shows up. Tapping on a given movie opens its respective movie info page.

* `stats_page.dart` : defines the stats page than summarizes some basic stats from the list of watched movies. Divided in three sections, it shows the following information:

    1. Overview:
        - Number of movies watched
        - Number of unique movies watched
        - Total watched time displayed in days-hours-minutes
    
    2. Most watched:
        - A list of the 10 most-watched movies

    3. Progress: 
        - A bar chart that displays the number of movies watched each year
    
### Services

* `databaseService.dart` : defines a `DatabaseService` class, used to create a database to store the watched movies, add and delete entries from it, and feth infomation. This class is used for displaying the watched movies on the home page and getting the stats shown in the stats page.

### Other files

* `main.dart` : acts as the entry point of the app. It starts up the app and defines the route name of each page.

## Future improvements

As the app was built to only satisfy some basic needs, there's still a multitude of features than could be added in future versions of the app.

1. Hability to edit individual entries. Currently, one has to delete an entry and enter it again with the new information.
2. Filters and sorting for the home page.
3. Filter stats by year or even specified time period.
4. Expand on the displayed stats.
5. Add a section within a movie info page, to show all the times one has watched said movie. 
6. Add info page for actors and directos.
7. Add feature to export the data as a json or csv file.
8. Change the way the information of each entry is displayed. Most likely change the text for icons to make it look cleaner.
9. Change date picker color to make it more consistent with the aesthetic of the app.
10. Make the app available for iOS.

## Known issues

There are currently one known issue of the app.

1. When deleting an entry, the stats page does not get immediately updated. One has to either restart the app or go to the search page and then go back to the stats page for it to update properly.