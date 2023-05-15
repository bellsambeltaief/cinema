import 'dart:convert';

import 'package:cinemamovie/Screens/signin.dart';
import 'package:cinemamovie/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserProfileMenu extends StatefulWidget {
  @override
  State<UserProfileMenu> createState() => _UserProfileMenuState();
}

class _UserProfileMenuState extends State<UserProfileMenu> {
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
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user.userName),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user.image),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    // Do something
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
