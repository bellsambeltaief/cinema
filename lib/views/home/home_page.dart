import 'dart:convert';
import 'package:cinemamovie/models/user.dart';
import 'package:cinemamovie/views/profile/profile_page.dart';
import 'package:cinemamovie/views/movie_category/movie_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
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

  void getcategories() async {
    await dotenv.load(fileName: ".env");
    var res = await get(Uri.parse("http://192.168.100.57:5000/api/categorie"));

    setState(() {
      categories = jsonDecode(res.body);
      selectedCategorie = categories[0]["name"];
    });
  }

  void getuserData() async {
    const storage = FlutterSecureStorage();

    String? cartData = await storage.read(key: "cartData");
    if (cartData == null) {
      await storage.write(key: "cartData", value: jsonEncode([]));
    }

    String? userData = await storage.read(key: "userData");
    var jsonUser = jsonDecode(userData!);

    setState(() {
      user =
          User(jsonUser["email"], "", jsonUser["userName"], jsonUser["image"]);
    });
  }

  void getmovies() async {
    await dotenv.load(fileName: ".env");
    var res = await get(Uri.parse("http://192.168.100.57:5000/api/film/"));

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello ${user.userName}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500),
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
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                          child: (user.image == "")
                              ? Container()
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(user.image),
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
                          margin:
                              const EdgeInsets.fromLTRB(5.0, 0.0, 10.0, 0.0),
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
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: const MovieApp(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
