import 'package:flutter/material.dart';
import 'package:Documents/home.dart';
import 'package:Documents/cards.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stripe',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(),
        '/cards': (context) => CardsPage(),
      },
    );
  }
}
