import 'dart:convert';
import 'dart:js_interop';
import 'package:cinemamovie/models/movie.dart';

import 'package:cinemamovie/views/booking/widgets/booking_text.dart';
import 'package:cinemamovie/views/booking/widgets/price_content.dart';
import 'package:cinemamovie/views/booking/widgets/seats_condition.dart';
import 'package:cinemamovie/views/booking/widgets/seats_content.dart';
import 'package:cinemamovie/views/payment.dart';

import 'package:cinemamovie/views/projection/projection_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class Booking extends StatefulWidget {
  final movieData;
  final Movie movie;
  const Booking({
    Key? key,
    this.movieData,
    required this.movie,
  }) : super(key: key);

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  var cinemas = [];
  var projs = [];

  List<int> unavailableSeats = [0, 11, 18, 22, 29, 34, 35, 37, 12, 40, 41];
  List<int> selectedSeats = [];

  int selectedCinIdx = 0;
  int selectedTimeIdx = 0;
  String formattedDate(dateString) {
    DateTime parsedDate = DateTime.parse(dateString);

    return "${(parsedDate.hour >= 12) ? (parsedDate.hour - 12) : (parsedDate.hour)}:${parsedDate.minute} ${(parsedDate.hour >= 12) ? "PM" : "AM"}";
  }

  void getPrice() async {
    await dotenv.load(fileName: ".env");

    var res = await get(
        Uri.parse("http://192.168.100.57:5000/api/projections/getProjection"));
    debugPrint(res.body);

    setState(() {
      projs = jsonDecode(res.body);
    });
  }

  void getCinemas() async {
    await dotenv.load(fileName: ".env");
    var res = await get(Uri.parse("http://192.168.100.57:5000/api/cinema"));

    setState(() {
      cinemas = jsonDecode(res.body);
    });
  }

  void getStorageMovie() {
    const storage = FlutterSecureStorage();

    storage.read(key: "cartData").then((cartData) {
      var matchMovie = jsonDecode(cartData!)
          .where((i) => i["_id"] == widget.movie.id)
          .toList();
      if (matchMovie.length != 0) {
        setState(() {
          selectedSeats = matchMovie[0]["seats"].cast<int>();
        });
      }
    });
  }

  List<dynamic> handleCartAdd(cartData, movie) {
    var matchMovie = cartData.where((i) => i["_id"] == movie["_id"]).toList();
    if (matchMovie.length != 0) {
      cartData.removeWhere((i) => i["_id"] == movie["_id"]);
      matchMovie[0]["seats"] = movie["seats"];
      matchMovie[0]["prix"] = movie["prix"];
      cartData.add(matchMovie[0]);
      return cartData;
    } else {
      cartData.add(movie);
      return cartData;
    }
  }

  @override
  void initState() {
    getStorageMovie();
    getPrice();
    getCinemas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Booking',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF2b2a3a),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(widget.movie.image),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Text(
                          //   widget.movie.category,
                          //   style: const TextStyle(color: Colors.white),
                          // ),
                          const SizedBox(height: 10),
                          Text(
                            ('${widget.movie.age}'),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.movie.type,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: (MediaQuery.of(context).size.width - 50.0),
                margin: const EdgeInsets.fromLTRB(25.0, 25.0, 0, 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: const Color(0xFF2b2a3a),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: const Text(
                        "Select Your Seats",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SeatsContent(),
                        SeatsContent(),
                      ],
                    ),
                  ],
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SeatsCondition(
                    conditionText: 'Reserved',
                    iconColor: Colors.grey,
                  ),
                  SeatsCondition(
                    conditionText: 'Available',
                    iconColor: Colors.white,
                  ),
                  SeatsCondition(
                    conditionText: 'Selected',
                    iconColor: Colors.yellow,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 300.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2b2a3a),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BookingText(),
                      const ProjectionApp(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // PriceContent(
                            //     text:
                            //         "${projs.isEmpty ? "10" : (projs[selectedTimeIdx]["prix"]).toString()} dt"),
                            Container(
                              width: 200.0,
                              height: 40.0,
                              margin: const EdgeInsets.only(left: 15.0),
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
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Payment(),
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
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
