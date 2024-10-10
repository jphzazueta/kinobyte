class MovieInfo {
  String title;
  int movieId;
  String year;
  String imageUrl;
  int runtime;

  MovieInfo({
    required this.title, 
    required this.movieId, 
    required this.year, 
    required this.imageUrl, 
    required this.runtime});

  factory MovieInfo.fromJson(Map<String, dynamic> json) {
    return MovieInfo(
      title: json['title'],
      year: json['release_date'] ?? '',
      movieId: json['id'],
      imageUrl: json['poster_path'] ?? '/865DntZzOdX6rLMd405R0nFkLmL.jpg',
      runtime: json['runtime'] ?? 0,
    );
  }
}