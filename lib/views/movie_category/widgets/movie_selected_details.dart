import 'package:cinemamovie/models/movie.dart';
import 'package:cinemamovie/views/booking/booking.dart';
import 'package:flutter/material.dart';

class MovieSelectedDetails extends StatelessWidget {
  const MovieSelectedDetails({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: (MediaQuery.of(context).size.width - 50.0),
      height: 230.0,
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2b2a3a),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            movie.image,
            height: 60,
            width: 60,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                movie.category,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                ('${movie.age}'),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                movie.type,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
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
                        builder: (context) => Booking(
                          movieData: movie,
                          movie: movie,
                        ),
                      ),
                    );
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
          ),
        ],
      ),
    );
  }
}
