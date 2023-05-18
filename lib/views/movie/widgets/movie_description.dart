import 'package:flutter/material.dart';

class MovieDescription extends StatelessWidget {
  const MovieDescription({
    super.key, required this.title,
  });
final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(
              10.0, 0, 0, 10.0),
          child: const Text(
            "Description",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600),
          ),
        ),
           Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10.0),
      margin: const EdgeInsets.only(bottom: 15.0),
      child: Text(
      title,
        style: const TextStyle(color: Colors.white),
      ),
    ),
      ],
    );
  }
}


