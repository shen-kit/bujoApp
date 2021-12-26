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

enum HabitStates { future, done, failed, excused, notToday }

class CheckboxColors {
  const CheckboxColors();

  // white
  static Color whiteOutline = const Color(0xFFFFFFFF);
  static Color whiteOutlineDim = const Color(0x90FFFFFF);
  static Color whiteInside = const Color(0x20FFFFFF);
  static Color whiteInsideDim = const Color(0x10FFFFFF);

  // red
  static Color redOutline = const Color(0xFFF40000);
  static Color redOutlineDim = const Color(0x90F40000);
  static Color redInside = const Color(0x20F40000);
  static Color redInsideDim = const Color(0x10F40000);

  // green
  static Color greenOutline = const Color(0xFF00F400);
  static Color greenOutlineDim = const Color(0x9000F400);
  static Color greenInside = const Color(0x2000F400);
  static Color greenInsideDim = const Color(0x1000F400);

  // blue
  static Color blueOutline = const Color(0xff00C8F4);
  static Color blueOutlineDim = const Color(0x9000C8F4);
  static Color blueInside = const Color(0x2000C8F4);
  static Color blueInsideDim = const Color(0x1000C8F4);

  // yellow
  static Color yellowOutline = const Color(0xffC3F400);
  static Color yellowOutlineDim = const Color(0x90C3F400);
  static Color yellowInside = const Color(0x20C3F400);
  static Color yellowInsideDim = const Color(0x10C3F400);
}
