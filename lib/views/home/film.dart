import 'dart:convert';

import 'package:cinemamovie/views/booking/booking.dart';
import 'package:cinemamovie/views/movie/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Film {
  final String titre;
  final String categorie;

  Film({required this.titre, required this.categorie});

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      titre: json['titre'],
      categorie: json['categorie'],
    );
  }
}

class FilmsParCategorie extends StatefulWidget {
  final String idCategorie;

  FilmsParCategorie({required this.idCategorie});

  @override
  _FilmsParCategorieState createState() => _FilmsParCategorieState();
}

class _FilmsParCategorieState extends State<FilmsParCategorie> {
  List<Film> films = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _getFilms();
  }

  Future<void> _getFilms() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:5000/films/categorie/:idCategorie",getFilmsByIdCategorie'),
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> jsonFilms = jsonBody['films'];
        setState(() {
          films = jsonFilms.map((jsonFilm) => Film.fromJson(jsonFilm)).toList();
          isLoading = false;
        });
      } else {
        print('Erreur lors de la récupération des films');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Erreur lors de la récupération des films: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Films par catégorie'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: films.length,
              itemBuilder: (BuildContext context, int index) {
                final film = films[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetail(movieData: film)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color.fromARGB(255, 2, 1, 17),
                      ),
                      height: 230.0,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      width: MediaQuery.of(context).size.width - 25.0,
                      child: Row(
                        children: [
                          // Container(
                          //   margin: const EdgeInsets.symmetric(horizontal: 15.0),
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(10.0),
                          //     child: SizedBox(
                          //       width: 130.0,
                          //       height: 200.0,
                          //       child: Image.network(movie["image"], fit: BoxFit.cover),
                          //     ),
                          //   ),
                          // ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Text(
                                      film.titre,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18.0),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      film.categorie,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 35.0,
                                margin: const EdgeInsets.only(bottom: 5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color(0xfff64c18),
                                      Color(0xffff8a1b)
                                    ],
                                    stops: [0.0, 1.0],
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Booking(movieData: film)));
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
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ListView.builder(
//               itemCount: films.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final film = films[index];
//                 return ListTile(
//                   title: Text(film.titre),
//                   subtitle: Text(film.categorie),
//                 );
//               },
//             ),
