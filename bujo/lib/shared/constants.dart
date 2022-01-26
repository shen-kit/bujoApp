import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle headerStyle = GoogleFonts.handlee(fontSize: 20);

const textInputDecoration = InputDecoration(
    // fillColor: Colors.white,
    // filled: true,
    // enabledBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.white, width: 2.0),
    // ),
    // focusedBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.blue, width: 2.0),
    // ),
    // hintStyle: TextStyle(color: Colors.black54),
    );

const textInputStyle = TextStyle(); //color: Colors.black);

enum HabitStates { future, done, partial, failed, excused, notToday }

class CheckboxColors {
  const CheckboxColors();

  static Color white = const Color(0xFFFFFFFF);
  static Color red = const Color(0xFFF40000);
  static Color green = const Color(0xFF00F400);
  static Color blue = const Color(0xFF00C8F4);
  static Color yellow = const Color(0xffC3F400);

  static double innerOpacity = 0.15;
  static double outlineOpacity = 1;
  static double innerOpacityDim = 0.1;
  static double outlineOpacityDim = 0.5;
}
