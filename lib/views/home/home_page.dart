import 'dart:convert';

import 'package:cinemamovie/models/user.dart';
import 'package:cinemamovie/views/booking/booking.dart';
import 'package:cinemamovie/views/cart/cart.dart';
import 'package:cinemamovie/views/movie_detail.dart';
import 'package:cinemamovie/views/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user = User("", "", "", "");
  var movies = [];
  String query = "";
  var categories = [];
  String selectedCategorie = "";
    int _selectedIndex = 0;

  void getcategories() async {
    await dotenv.load(fileName: ".env");
    var res = await get(Uri.parse("${dotenv.env['BASE_URL']}/categorie"));

    setState(() {
      categories = jsonDecode(res.body);
      selectedCategorie = categories[0]["name"];
    });
  }

  void getuserData() async {
    const storage = FlutterSecureStorage();

    String? cartData = await storage.read(key: "cartData");
    if(cartData == null) {
      await storage.write(key: "cartData", value: jsonEncode([]));
    }

    String? userData = await storage.read(key: "userData");
    var jsonUser = jsonDecode(userData!);

    setState(() {
      user = User(
          jsonUser["email"],
          "",
          jsonUser["userName"],
          jsonUser["image"]
      );
    });
  }

  void getmovies() async {
    await dotenv.load(fileName: ".env");
    var res = await get(Uri.parse("${dotenv.env['BASE_URL']}/film"));

    setState(() {
      movies = jsonDecode(res.body);
    });
  }

  String parseDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return ("${date.year}-${date.month}-${date.day}");
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  void initState() {
    getuserData();
    getmovies();
    getcategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      
     bottomNavigationBar: CurvedNavigationBar(
 backgroundColor: Colors.black,
          color: Color.fromARGB(255, 255, 213, 0),
          buttonBackgroundColor: Color.fromARGB(255, 255, 213, 0),
          height: 50,
  index: _selectedIndex,
  onTap: (index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>ProfilePage(),
        ),
      );
    } else if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>HomePage(),
        ),
      );

    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Cart(),
        ),
      );

    }
    _selectedIndex = index;
  },
  items: const <Widget>[
    Icon(Icons.home_filled, size: 30),
    Icon(Icons.shopping_cart, size: 30),
    Icon(Icons.account_circle_rounded, size: 30),
  ],
),


      body: SingleChildScrollView(
        
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Text(
          "Hello ${user.userName}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w500
          ),
        ),
        const Text(
          "What are you watching today ?",
          style: TextStyle(
            color: Colors.white54,
          ),
        )
      ],
    ),
    Expanded(
      child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ),);
    },
      child: (user.image == "") ? Container() : CircleAvatar(
        radius: 50,
        backgroundImage:NetworkImage(user.image),
      ),
    )),
  ],
),

                ),
                Container(
                
                  padding: const EdgeInsets.all(7.5),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF292B37),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(5.0, 0.0, 10.0, 0.0),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 300,

                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            query = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type in a movie name',
                          hintStyle: TextStyle(color: Colors.white),
                        ),

                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ]),
                ),

              Container(
                margin: const EdgeInsets.only(top: 15.0),
                height: 40.0,
                width: MediaQuery.of(context).size.width,

                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(
                        height: 40.0,
                        width: 25.0,
                      ),

                      Row(
                        children: categories.map((categorie) =>
                            Container(
                              margin: const EdgeInsets.only(right: 10.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedCategorie = categorie["name"];
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ((selectedCategorie == categorie["name"]) ? Color.fromARGB(255, 255, 213, 0) : const Color(0xFF292B37)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),

                                child: Text(
                                  capitalize(categorie["name"]),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                        ).toList(),
                      )
                    ]
                  ),
                ),
              ),

              (movies.isEmpty) ? Container(
                child: Text("data", style: TextStyle(color: Colors.white, fontSize: 20),),
              ) : SingleChildScrollView(
                child: Column(
                    children: movies.where((movie) => (
                          movie["title"].toLowerCase().contains(query.toLowerCase()))
                        )
                        .map((movie) =>
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => MovieDetail(movieData: movie)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: const Color.fromARGB(255,2,1,17),
                              ),

                              height: 230.0,
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              width: MediaQuery.of(context).size.width - 25.0,
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: SizedBox(
                                        width: 130.0,
                                        height: 200.0,
                                        child: Image.network(movie["image"], fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),

                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                                            child: Text(
                                              movie["title"],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0
                                              ),
                                            ),
                                          ),

                                          Container(
                                            margin: const EdgeInsets.only(bottom: 10.0),
                                            child: Text(
                                              movie["type"],
                                              style: const TextStyle(
                                                  color: Colors.white
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

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
                                                context, MaterialPageRoute(builder: (context) => Booking(movieData: movie)));
                                            
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
                                  )
                                ],
                              ),
                    ),
                          ),
                        )).toList(),
                ),
              )
            ],
          ),
          ),
              ),
    );
  }
}