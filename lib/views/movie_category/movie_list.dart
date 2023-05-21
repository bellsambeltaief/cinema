import 'dart:convert';

import 'package:cinemamovie/models/movie.dart';
import 'package:cinemamovie/views/booking/booking.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Movie>> getMoviesByCategory(String category) async {
    print(category);
    final response = await http.get(
        Uri.parse('http://192.168.100.57:5000/api/film/categorie/$category'));
    print("${json.decode(response.body)}");
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return List<Movie>.from(jsonData.map((movie) => Movie.fromJson(movie)));
    } else {
      throw Exception('Failed to load movies');
    }
  }
}

class MovieList extends StatelessWidget {
  final String category;

  const MovieList({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: ApiService.getMoviesByCategory(category),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Movie> filteredMovies = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: filteredMovies.length,
                  itemBuilder: (context, index) {
                    final movie = filteredMovies[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18.0),
                        ),
                        Text(
                          movie.category,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          movie.description,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          movie.partner,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          ('${movie.age}'),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          movie.type,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          movie.image,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Container(
                          height: 35.0,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Color(0xfff64c18), Color(0xffff8a1b)],
                              stops: [0.0, 1.0],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Booking(movieData: movie)));
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              primary: Colors.transparent,
                              onSurface: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: const Text("Book A Ticket"),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return const Text("Erreur");
        }
      },
    );
  }
}
