import 'dart:convert';
import 'package:cinemamovie/models/movie.dart';
import 'package:cinemamovie/models/projection.dart';
import 'package:cinemamovie/views/projection/projection_selected_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Projection>> getProjection(
      String cinema) async {

    final response = await http.get(Uri.parse(
        'http://192.168.100.57:5000/api/projections/getProjection'));
    // print("${json.decode(response.body)}");
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return List<Projection>.from(
          jsonData.map((projection) => Projection.fromJson(projection)));
    } else {
      throw Exception('Failed to load projections');
    }
  }
}

class ProjectionList extends StatefulWidget {
  final String cinema;

  const ProjectionList({
    Key? key,
    required this.cinema,

  }) : super(key: key);

  @override
  State<ProjectionList> createState() => _ProjectionListState();
}

class _ProjectionListState extends State<ProjectionList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Projection>>(
      future: ApiService.getProjection(
          widget.cinema),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Projection> filteredProjections = snapshot.data!;
          return Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: filteredProjections.length,
              itemBuilder: (context, index) {
                final projection = filteredProjections[index];
                return ProjectionsSelectedDetails(
                  projection: projection,
                );
              },
            ),
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
