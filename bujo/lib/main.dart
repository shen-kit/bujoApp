import 'package:flutter/material.dart';

import 'package:bujo/screens/authenticate/authenticate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xff40CDC5),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.white,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        scaffoldBackgroundColor: const Color(0xff1A2960),
      ),
      home: const SafeArea(
        child: Authenticate(),
      ),
    );
  }
}
