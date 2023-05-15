import 'package:cinemamovie/Screens/BannerWidget.dart';
import 'package:cinemamovie/Screens/HomePage.dart';
import 'package:cinemamovie/Screens/logoScreen.dart';
import 'package:cinemamovie/Screens/signin.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme:ThemeData(
      scaffoldBackgroundColor: const Color(0xFF0F111D),
    ),
    home: LogoScreen(),
  ));
}