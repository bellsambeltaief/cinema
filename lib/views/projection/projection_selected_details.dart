import 'package:cinemamovie/models/projection.dart';
import 'package:cinemamovie/views/projection/cinema_button.dart';
import 'package:flutter/material.dart';

class ProjectionsSelectedDetails extends StatelessWidget {
  const ProjectionsSelectedDetails({
    super.key,
    required this.projection,
  });

  final Projection projection;

  @override
  Widget build(BuildContext context) {
    return CinemaButton(
        text: projection.dateProjection.hour.toString(), onPressed: () {});
  }
}
