import 'package:cinemamovie/views/booking/booking.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  var cartMovies = [];
  void getMovies() async {
    const storage = FlutterSecureStorage();
    String? cartData = await storage.read(key: "cartData");

    setState(() {
      cartMovies = jsonDecode(cartData!);
    });
  }

  num calcPrice() {
    num price = 0;

    for (var movie in cartMovies) {
      price += (movie["seats"].length) * movie["price"];
    }

    return price;
  }

  @override
  void initState() {
    getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
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
      body: Stack(
        children: [
          Positioned(
            top: 100.0,
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.height - 200.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: cartMovies
                    .map(
                      (movie) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Booking(movieData: movie)));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: (MediaQuery.of(context).size.width - 50.0),
                          height: 230.0,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          margin: const EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 2, 1, 17),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: SizedBox(
                                    width: 130.0,
                                    height: 200.0,
                                    child: Image.network(movie["image"],
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Text(
                                              movie["title"],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: Text(
                                              movie["type"],
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: Text(
                                              movie["cinema"],
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: Text(
                                              "${movie["price"].toString()} DT",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 230,
                                    width: (MediaQuery.of(context).size.width -
                                        225.0),
                                    alignment: Alignment.centerRight,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              )),
                                          Text(
                                            movie["seats"].length.toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Positioned(
            top: 30.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              alignment: Alignment.center,
              child: const Text(
                "My Cart",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Positioned(
            top: 30.0,
            left: 10.0,
            child: IconButton(
              onPressed: () {
                //_controller.pause();
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              alignment: Alignment.center,
              color: const Color.fromARGB(255, 2, 1, 17),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${calcPrice()} dt",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 200.0,
                    height: 40.0,
                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: const Color(0xffd3be01)),
                      child: const Text(
                        "Check Out",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
