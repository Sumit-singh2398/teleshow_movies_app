class Movie {
  final String title;
  final String poster;
  final String year;
  final String plot;

  Movie({
    required this.title,
    required this.poster,
    required this.year,
    required this.plot,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["Title"] ?? "N/A",
      poster: json["Poster"] ?? "N/A",
      year: json["Year"] ?? "N/A",
      plot: json["Plot"] ?? "",
    );
  }
}

