import 'package:cinemamovie/models/projection.dart';
import 'package:cinemamovie/views/projection/cinema_button.dart';
import 'package:flutter/material.dart';

class ProjectionsSelectedPrices extends StatefulWidget {
  const ProjectionsSelectedPrices({
    super.key,
    required this.projection,
  });

  final Projection projection;

  @override
  State<ProjectionsSelectedPrices> createState() =>
      _ProjectionsSelectedPricesState();
}

class _ProjectionsSelectedPricesState
    extends State<ProjectionsSelectedPrices> {
  String _selectedProjection = '';

  @override
  void initState() {
    super.initState();
  }

  void _onProjectionPressed(String prix) {
    setState(() {
      _selectedProjection = prix;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CinemaButton(
            text: widget.projection.dateProjection.hour.toString(),
            onPressed: () =>
                _onProjectionPressed(widget.projection.prix.toString()),
            isSelected: widget.projection.prix == _selectedProjection,
          ),
        ],
      ),
    );
  }
}
