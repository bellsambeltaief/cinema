import 'dart:convert';

import 'package:cinemamovie/Screens/signin.dart';
import 'package:cinemamovie/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserProfileMenu extends StatefulWidget {
  const UserProfileMenu({super.key});

  @override
  State<UserProfileMenu> createState() => _UserProfileMenuState();
}

class _UserProfileMenuState extends State<UserProfileMenu> {
  void logout() async {
    var url = "http://192.168.1.122:5000/api/users/logout";
    var response = await http.post(
      Uri.parse(url),
    );
    print(response.statusCode);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      final storage = const FlutterSecureStorage();
      await storage.delete(key: "userData");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignIn(),
        ),
      );
    } else {
      // erreur lors de l'appel à l'API, vous pouvez afficher un message d'erreur à l'utilisateur
      debugPrint("Erreur lors de la déconnexion");
    }
  }

  User user = User("", "", "", "");

  void _getUserData() async {
    final storage = const FlutterSecureStorage();

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
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    // Do something
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
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
