import 'package:aqua_bot/animations/wave.dart';
import 'package:aqua_bot/routes/home.dart';
import 'package:aqua_bot/routes/sign-in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AQUA BOT',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => FancyBackgroundApp(GoogleSignInPage()),0),
        '/home': (_) => HomePage(),
      },
    );
  }
}
