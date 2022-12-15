import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  backgroundColor: const Color(0xfff7f7fa),
  primaryColor: const Color(0xff38383b),
  bottomAppBarColor: Colors.white,
  textTheme: TextTheme(
    headline1: TextStyle(
      fontStyle: GoogleFonts.firaSans().fontStyle,
      color: const Color(0xff38383b),
      fontWeight: FontWeight.w800,
      fontSize: 22,
    ),
    subtitle1: TextStyle(
      fontStyle: GoogleFonts.firaSans().fontStyle,
      color: const Color(0xff38383b),
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
    subtitle2: TextStyle(
      fontStyle: GoogleFonts.firaSans().fontStyle,
      color: const Color(0xff38383b),
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),
    bodyText1: TextStyle(
      fontStyle: GoogleFonts.firaSans().fontStyle,
      color: const Color(0xff38383b),
      fontWeight: FontWeight.normal,
      fontSize: 16,
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  backgroundColor: const Color(0xff303131),
  primaryColor: Colors.white,
  bottomAppBarColor: const Color(0xff222224),
  textTheme: TextTheme(
    headline1: TextStyle(
      fontStyle: GoogleFonts.firaSans().fontStyle,
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 22,
    ),
    subtitle1: TextStyle(
      fontStyle: GoogleFonts.firaSans().fontStyle,
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
    subtitle2: TextStyle(
      fontStyle: GoogleFonts.firaSans().fontStyle,
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),
    bodyText1: TextStyle(
      fontStyle: GoogleFonts.firaSans().fontStyle,
      color: Colors.white,
      fontWeight: FontWeight.normal,
      fontSize: 16,
    ),
  ),
);