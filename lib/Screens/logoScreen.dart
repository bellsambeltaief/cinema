import 'package:cinemamovie/Screens/HomePage.dart';
import 'package:cinemamovie/Screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({Key? key}) : super(key: key);

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {

  void checkUserSignIn() async {
    const storage = FlutterSecureStorage();
    var existingData = await storage.read(key: "userData");

    Future.delayed(const Duration(seconds: 2), () {
      if(existingData != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }

      else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Signin()));
      }
    });
  }

  @override
  void initState() {
    checkUserSignIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        child: Center(
          child: Image.asset('images/logo.png'),
        ),
      ),
    );
  }
}
