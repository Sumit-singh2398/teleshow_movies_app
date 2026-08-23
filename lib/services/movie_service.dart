import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieServices {
  final String apiKey = "6a7fa001";

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final url = "https://www.omdbapi.com/?apikey=$apiKey&s=$query";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) return [];

      final data = json.decode(response.body);

      if (data["Response"] == "True" && data["Search"] != null) {
        List results = data["Search"];

        final movies = await Future.wait(
          results.map((item) => fetchMovieDetail(item["imdbID"])).toList(),
        );

        return movies;
      } else {
        debugPrint("OMDb Search Error: ${data["Error"]}");
        return [];
      }
    } catch (e) {
      debugPrint("Exception: $e");
      return [];
    }
  }

  Future<Movie> fetchMovieDetail(String imdbID) async {
    final url = "https://www.omdbapi.com/?apikey=$apiKey&i=$imdbID&plot=short";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return Movie(title: "N/A", poster: "N/A", year: "N/A", plot: "", rating: "N/A");
    }

    final data = json.decode(response.body);
    return Movie.fromJson(data);
  }
}