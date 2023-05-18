import 'dart:convert';
import 'package:cinemamovie/views/booking/widgets/booking_button.dart';
import 'package:cinemamovie/views/booking/widgets/booking_text.dart';
import 'package:cinemamovie/views/booking/widgets/movie_details.dart';
import 'package:cinemamovie/views/booking/widgets/price_content.dart';
import 'package:cinemamovie/views/booking/widgets/seats_condition.dart';
import 'package:cinemamovie/views/booking/widgets/seats_content.dart';
import 'package:cinemamovie/views/cart/cart.dart';
import 'package:cinemamovie/functions.dart';
import 'package:cinemamovie/views/booking/widgets/pressed_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class Booking extends StatefulWidget {
  final movieData;
  const Booking({
    Key? key,
     this.movieData,
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
    
    var res = await get(Uri.parse("http://192.168.1.21:5000/api/projections/getProjection"));
    debugPrint(res.body);

    setState(() {
      projs = jsonDecode(res.body);
    });
  }

  void getCinemas() async {
    await dotenv.load(fileName: ".env");
    var res =
        await get(Uri.parse("http://192.168.1.21:5000/api/cinema"));

    setState(() {
      cinemas = jsonDecode(res.body);
    });
  }

  void getStorageMovie() {
    const storage = FlutterSecureStorage();

    storage.read(key: "cartData").then((cartData) {
      var matchMovie = jsonDecode(cartData!)
          .where((i) => i["_id"] == widget.movieData["_id"])
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
      matchMovie[0]["price"] = movie["price"];
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
                const   SizedBox(  height: 10,),
              Container(
                height: 220.0,
                width: (MediaQuery.of(context).size.width - 50.0),
                margin: const EdgeInsets.only(left: 25.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF2b2a3a),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(10.0, 0, 20.0, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: SizedBox(
                          width: 130.0,
                          height: 200.0,
                          child: Image.network(widget.movieData["image"],
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MovieDetails(text:  widget.movieData["title"],),
                        MovieDetails(text:  widget.movieData["type"],),
                        MovieDetails(text:  widget.movieData["categorie"],),
                        MovieDetails(text:  widget.movieData["cinema"],),
                        MovieDetails(text:   parseDate(widget.movieData["date"]),),
                   
                      ],
                    ),
                  ],
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
                  SeatsCondition(conditionText: 'Reserved', iconColor: Colors.grey,),
                  SeatsCondition(conditionText: 'Available', iconColor: Colors.white,),
                  SeatsCondition(conditionText: 'Selected', iconColor: Colors.yellow,),
                ],
              ),
           const    SizedBox(height: 10),
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
                  Column(
                    children: [
                    const  BookingText(),
            
                 PressedButton(list:   Row(
                                children: cinemas.asMap().entries.map((entry) =>
                                    Container(
                                      margin: const EdgeInsets.only(right: 15.0),
            
                                      child: ElevatedButton(
                                        onPressed: () {
                                       setState(() {
                                            selectedCinIdx = entry.key;
                                      
                                       });
                                        },
            
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ((selectedCinIdx == entry.key) ? const Color(0xFFD2BE07) : const Color(0xFF939194)),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                        ),
            
                                        child: Text(
                                          entry.value["name"],
                                          style: const TextStyle(
                                              fontSize: 17.0
                                          ),
                                        ),
                                      ),
                                    ),
                                ).toList(),
                              ),),
         if (selectedCinIdx == selectedTimeIdx) ... [
              PressedButton( list:
                              Row(
                                children: projs.asMap().entries.map((entry) =>
                                    Container(
                                      margin: const EdgeInsets.only(right: 15.0),
            
                                      child: ElevatedButton(
                                        onPressed: () {
                                       setState(() {
                                            selectedTimeIdx = entry.key;
                                      
                                       });
                                        },
            
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ((selectedTimeIdx == entry.key) ? const Color(0xFFD2BE07) : const Color(0xFF939194)),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                        ),
            
                                        child: Text(
                                              formattedDate(entry.value["dateProjection"]),
                                          style: const TextStyle(
                                              fontSize: 17.0
                                          ),
                                        ),
                                      ),
                                    ),
                                ).toList(),
                              ) ,),
                    ] ,
                    
                    ],
                  ),
            
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        
                        PriceContent(text:    "${projs.isEmpty ? "0" : (projs[selectedTimeIdx]["prix"] ).toString()} dt"),
                         BookingButton(tapped:    () async {
                    if (selectedSeats.isEmpty) return;
            
                    const storage = FlutterSecureStorage();
                    String? cartData =
            await storage.read(key: "cartData");
            
                    var jsonCartData = jsonDecode(cartData!);
                    var addMovie = widget.movieData;
                    addMovie["seats"] = selectedSeats;
                    addMovie["price"] =
            projs[selectedTimeIdx]["prix"];
            
                    jsonCartData.add(widget.movieData);
                    //await storage.write(key: "cartData", value: jsonEncode([]));
            
                    storage
            .write(
                key: "cartData",
                value: jsonEncode(handleCartAdd(
                    jsonCartData, addMovie)))
            .then((res) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const Cart()));
                    });
                  },),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}

