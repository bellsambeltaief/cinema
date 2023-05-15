import 'dart:convert';
import 'package:cinemamovie/Screens/HomePage.dart';
import 'package:cinemamovie/Screens/signin.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cinemamovie/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


    void logout() async {
    var url = "http://192.168.59.65:5000/api/users/logout";
    var response = await http.post(Uri.parse(url));
    print(response.statusCode);
print(response.body);
    if (response.statusCode == 200) {
      final storage = FlutterSecureStorage();
      await storage.delete(key: "userData");
     Navigator.push(
          context, MaterialPageRoute(builder: (context) => Signin()));
    } else {
      // erreur lors de l'appel à l'API, vous pouvez afficher un message d'erreur à l'utilisateur
      print("Erreur lors de la déconnexion");
    }
  }


  User user = User("", "", "", "");
    int _selectedIndex = 0;
  void _getUserData() async {
    final storage = FlutterSecureStorage();

    String? userData = await storage.read(key: "userData");
    var jsonUser = jsonDecode(userData!);

    setState(() {
      user = User(
        jsonUser["email"],
        "",
        jsonUser["userName"],
        jsonUser["image"],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 213, 0),

        elevation: 0,
      ),
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

    }
    _selectedIndex = index;
  },
  items: <Widget>[
    Icon(Icons.home_filled, size: 30),
    Icon(Icons.shopping_cart, size: 30),
    Icon(Icons.account_circle_rounded, size: 30),
  ],
),

      
      
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 32),
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all( color: Color.fromARGB(255, 255, 213, 0), width: 2),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(user.image),
                ),
              ),
              child: (user.image == "")
                  ? Icon(Icons.person, color: Colors.white, size: 48)
                  : null,
            ),
            SizedBox(height: 32),
             Row(
              children: <Widget>[
                Icon(Icons.person, color: Colors.white, size: 24),
                SizedBox(width: 16),
            Text(
              '${user.userName}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 24,
               color: Color.fromARGB(255, 255, 213, 0),
              ),
            )]),
            SizedBox(height: 16),
            Divider(
              height: 32,
              color: Color.fromARGB(255, 255, 213, 0)
            ),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                Icon(Icons.email, color: Colors.white, size: 24),
                SizedBox(width: 16),
                Text(
                  '${user.email}',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

               SizedBox(height: 16),
           
  GestureDetector(
  onTap: logout,
  child: Row(
    children: <Widget>[
      Icon(Icons.logout, color: Colors.white, size: 24),
      SizedBox(width: 16),
      Text(
        'Logout',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    ],
  ),
),


          ],
        ),
      ),
    );
  }
}
