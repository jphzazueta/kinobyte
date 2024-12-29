class MovieInfo {
  String title;
  int movieId;
  String year;
  String? imageUrl;

  MovieInfo({
    required this.title, 
    required this.movieId, 
    required this.year, 
    required this.imageUrl, 
    });

  factory MovieInfo.fromJson(Map<String, dynamic> json) {
    return MovieInfo(
      title: json['title'],
      year: json['release_date'] ?? '',
      movieId: json['id'],
      imageUrl: json['poster_path'],
    );
  }
}