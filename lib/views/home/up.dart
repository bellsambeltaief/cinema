import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Film {
  final String id;
  final String title;
  final String categoryId;

  Film({required this.id, required this.title, required this.categoryId});

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'],
      title: json['title'],
      categoryId: json['categoryId'],
    );
  }
}

class FilmsByCategoryPage extends StatefulWidget {
  final String categoryId;

  FilmsByCategoryPage({required this.categoryId});

  @override
  _FilmsByCategoryPageState createState() => _FilmsByCategoryPageState();
}

class _FilmsByCategoryPageState extends State<FilmsByCategoryPage> {
  List<Film> _films = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getFilmsByIdCategorie(widget.categoryId);
  }

  Future<void> _getFilmsByIdCategorie(String idCategorie) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.21:5000/categorie/'));

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> jsonFilms = jsonBody['films'];
        setState(() {
          _films = jsonFilms.map((jsonFilm) => Film.fromJson(jsonFilm)).toList();
          _isLoading = false;
        });
      } else {
        print('Error retrieving films');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error retrieving films: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 350,
      child:  _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _films.length,
              itemBuilder: (BuildContext context, int index) {
                final film = _films[index];
                               return ListTile(
                  title: Text(film.title),
                
                  subtitle: Text(film.categoryId),
                );
              },
            ),
    );

  }
}