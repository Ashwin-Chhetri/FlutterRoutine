import 'package:flutter/material.dart';

class AppTheme {
  static String appName = "MyTimeTableApp";

  // Light Theme
  static const Color lightPrimary = Color(0xFF2F4051);
  static const Color lightOnPrimary = Color(0xFFFDFCF7);
  static const Color lightSecondary = Color(0xFFFDFCF7);
  static const Color lightOnSecondary = Color(0xFF2F4051);
  static const Color lightBG = Color(0xFFA5CDE6);
  static const Color lightBottomNavBackground = Color(0xFFADBFCB);
  static const Color shadowColor = Colors.grey;
  static const double navIconSize = 30.0;

  static final light = ThemeData(
    useMaterial3: true,
    fontFamily: 'Manrope',
    unselectedWidgetColor: Colors.white,
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: lightPrimary,
        onPrimary: lightOnPrimary,
        secondary: lightSecondary,
        onSecondary: lightOnSecondary,
        error: Colors.red,
        onError: Colors.black,
        background: lightBG,
        onBackground: lightBG,
        surface: lightBG,
        onSurface: Colors.black),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: lightBottomNavBackground,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(
              size: 30.0, weight: 100, color: Colors.white);
        }
        return const IconThemeData(
            size: 30.0, weight: 100, color: Colors.white);
      }),
    ),
    checkboxTheme: CheckboxThemeData(
        //fillColor: MaterialStateProperty.all(Colors.white),
        checkColor: MaterialStateProperty.all(Colors.white),
        side: const BorderSide(color: Colors.white)),
  );

  static const largeTitleTextStyle = TextStyle(
      color: AppTheme.lightPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 2.0);

  static const headlineTextStyle = TextStyle(
      overflow: TextOverflow.ellipsis,
      color: AppTheme.lightPrimary,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.9);

  static const bodyTextStyle = TextStyle(
      overflow: TextOverflow.ellipsis,
      color: AppTheme.lightPrimary,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.9);

  static final labelStyle = TextStyle(
      color: lightPrimary.withOpacity(0.7),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.0);

  static const errorStyle = TextStyle(
    color: Colors.red,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
  );

  static final UnderlineInputBorder enabledBorder = UnderlineInputBorder(
    borderSide: BorderSide(width: 1, color: lightPrimary.withOpacity(0.7)),
    //borderRadius: BorderRadius.circular(10),
  );

  static const UnderlineInputBorder focusedBorder = UnderlineInputBorder(
    borderSide: BorderSide(width: 2, color: lightPrimary),
    //borderRadius: BorderRadius.circular(10),
  );
}
