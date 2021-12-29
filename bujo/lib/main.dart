import 'package:bujo/screens/wrapper.dart';
import 'package:bujo/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xff1A2960)));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        title: 'Bullet Journal',
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
          child: Wrapper(),
        ),
      ),
    );
  }
}
