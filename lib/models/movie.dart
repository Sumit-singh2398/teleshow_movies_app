class Movie {
  final String title;
  final String poster;
  final String year;
  final String plot;
  final String rating;
  final String genre;

  Movie({
    required this.title,
    required this.poster,
    required this.year,
    required this.plot,
    required this.rating,
    required this.genre,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["Title"] ?? "N/A",
      poster: json["Poster"] ?? "N/A",
      year: json["Year"] ?? "N/A",
      plot: json["Plot"] ?? "No description available.",
      rating: json["imdbRating"] ?? "N/A",
      genre: json["Genre"] ?? "Unknown",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Title": title,
      "Poster": poster,
      "Year": year,
      "Plot": plot,
      "imdbRating": rating,
      "Genre": genre,
    };
  }

  factory Movie.fromMap(Map<dynamic, dynamic> map) {
    return Movie(
      title: map["Title"] ?? "N/A",
      poster: map["Poster"] ?? "N/A",
      year: map["Year"] ?? "N/A",
      plot: map["Plot"] ?? "No description available.",
      rating: map["imdbRating"] ?? "N/A",
      genre: map["Genre"] ?? "Unknown",
    );
  }
}