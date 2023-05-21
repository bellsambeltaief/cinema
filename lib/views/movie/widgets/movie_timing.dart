import 'package:flutter/material.dart';

class MovieTiming extends StatelessWidget {
  const MovieTiming({
    super.key,
    required this.time,
    required this.timeText,
  });
  final String timeText;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          timeText,
          style: const TextStyle(
              color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w500),
        ),
        Text(
          time,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
