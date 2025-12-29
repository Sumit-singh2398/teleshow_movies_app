import 'package:flutter/material.dart';
import 'models/movie.dart';
import 'services/movie_service.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatefulWidget {
  const MovieApp({super.key});

  @override
  State<MovieApp> createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "TeleShow Movies",
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: MovieScreen(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
    );
  }
}

class MovieScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  const MovieScreen({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final MovieServices service = MovieServices();
  List<Movie> movies = [];
  bool isLoading = false;
  String query = "batman";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = query;
    fetchMovies();
  }

  void fetchMovies() async {
    setState(() {
      isLoading = true;
      movies = [];
    });

    final results = await service.searchMovies(query);
    setState(() {
      movies = results;
      isLoading = false;
    });
  }

  Future<void> refreshMovies() async => fetchMovies();

  Widget buildMovieGridCard(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailScreen(movie: movie),
            ));
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: movie.poster != "N/A"
                ? Image.network(
                    movie.poster,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Colors.grey,
                    child: const Icon(Icons.movie, size: 50),
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
              ),
              child: Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TeleShow Movies"),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      query = value.trim();
                      if (query.isNotEmpty) fetchMovies();
                    },
                    decoration: InputDecoration(
                      hintText: "Search movies...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _controller.clear(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    query = _controller.text.trim();
                    if (query.isNotEmpty) fetchMovies();
                  },
                  child: const Text("Search"),
                )
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : movies.isEmpty
                    ? const Center(child: Text("No movies found"))
                    : RefreshIndicator(
                        onRefresh: refreshMovies,
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            return buildMovieGridCard(movies[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              movie.poster != "N/A"
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(movie.poster),
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey,
                      child: const Icon(Icons.movie, size: 100),
                    ),
              const SizedBox(height: 16),
              Text(
                movie.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                movie.year,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                movie.plot,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
