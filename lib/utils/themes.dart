import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoxioThemes {
   Map<String, ThemeData> get map => {
    'Light Theme': lightTheme,
    'Dark Theme': darkTheme,
    'Black Theme': blackTheme,
    'Sky Theme': skyTheme,
  };

  final lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Colors.white,
      actionsIconTheme: IconThemeData(color: Colors.black38),
      iconTheme: IconThemeData(color: Colors.black38),
    ),
    brightness: Brightness.light,
    textTheme: GoogleFonts.mulishTextTheme(),
    buttonTheme: ButtonThemeData(
      shape: StadiumBorder(),
      textTheme: ButtonTextTheme.primary,
    ),
  );

  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.lightBlue,
    textTheme: GoogleFonts.mulishTextTheme(
      TextTheme(),
    ),
    buttonTheme: ButtonThemeData(
      shape: StadiumBorder(),
    ),
  );

  ThemeData get blackTheme => ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.lightBlue,
    textTheme: GoogleFonts.mulishTextTheme(
      TextTheme(),
    ),
    buttonTheme: ButtonThemeData(
      shape: StadiumBorder(),
    ),
    // backgroundColor: Colors.black87,
    scaffoldBackgroundColor: Colors.black87,
    dialogBackgroundColor: Colors.grey.shade900,
    appBarTheme: AppBarTheme(
      color: Colors.black
    )
  );

  ThemeData get skyTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.indigo.shade900,
    dialogBackgroundColor: Colors.indigo.shade800,
    appBarTheme: AppBarTheme(color: Colors.indigo.shade700),
    textTheme: GoogleFonts.mulishTextTheme(
      TextTheme(),
    ),
    buttonTheme: ButtonThemeData(
      shape: StadiumBorder(),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.indigo,
      modalBackgroundColor: Colors.indigo,
    ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightBlue).copyWith(background: Colors.indigo.shade900),
  );
}
