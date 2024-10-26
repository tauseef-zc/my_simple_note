import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteTheme {
  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: lightBlue,
      textTheme: lightTextTheme,
      secondaryHeaderColor: Colors.grey.shade300,
      primaryColor: lightBlue,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: lightBlue));

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: lightTextTheme,
      secondaryHeaderColor: Colors.black54,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: lightBlue));

  static TextTheme lightTextTheme = TextTheme(
      headlineLarge: GoogleFonts.poppins(
        color: lightBlue,
        fontSize: 64,
        height: 0.9,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.inter(
          color: lightBlue,
          fontSize: 30,
          height: 1,
          fontWeight: FontWeight.w600));

  static MaterialColor lightBlue = const MaterialColor(0xFF30A2CC, <int, Color>{
    50: Color(0xFF4ABBE8),
    100: Color(0xFF3BADD6),
    200: Color(0xFF36A6CF),
    300: Color(0xFF35A6CF),
    400: Color(0xFF37A7D1),
    500: Color(0xFF30A2CC),
    600: Color(0xFF2C9DC6),
    700: Color(0xFF2A9CC5),
    800: Color(0xFF187C9E),
    900: Color(0xFF157B9E),
  });
}
