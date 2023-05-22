import 'package:cinemamovie/models/movie.dart';

class Projection {
  final DateTime dateProjection;
  final double prix;
  final String id;
  final String name;
  final String cinemaId;
  final String filmId;

  Projection({
    required this.id,
    required this.name,
    required this.prix,
    required this.dateProjection,
    required this.cinemaId,
    required this.filmId,
  });

  factory Projection.fromJson(Map<String, dynamic> json) {
    return Projection(
      id: json['_id'].toString(),
      name: json['name'].toString(),
      cinemaId: json['cinemaId'].toString(),
      dateProjection: DateTime.parse(json['dateProjection']),
      filmId: json['filmId'],
      prix: json['prix'],
    );
  }
}
