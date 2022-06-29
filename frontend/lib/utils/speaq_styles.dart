import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//region Colors
const Color spqPrimaryBlue = Color(0xFF3388DD);
const Color spqPrimaryBlueTranslucent = Color(0x773388DD);
const Color spqSecondaryAqua = Color(0xFF11CCFF);
const Color spqSecondaryAquaTranslucent = Color(0x7711CCFF);
const Color spqLightRed = Color(0xFFFF5252);
const Color spqLightYellow = Color(0xFFFFFF00);
const Color spqLightGreen = Color(0xFF8BC34A);
const Color spqWarningOrange = Color(0xFFFF9944);
const Color spqWarningOrangeTranslucent = Color(0x77FF9944);
const Color spqErrorRed = Color(0xFFFF1111);
const Color spqErrorRedTranslucent = Color(0x77FF1111);
//endregion

//region Black/White
const Color spqWhite = Color(0xFFF9F9F9);
const Color spqWhiteTranslucent = Color(0x77F9F9F9);
const Color spqLightGrey = Color(0xFFCCCCCC);
const Color spqLightGreyTranslucent = Color(0x77CCCCCC);
const Color spqBackgroundGrey = Color(0xFFE7ECF0);
const Color spqBackgroundGreyTranslucent = Color(0x77E7ECF0);
const Color spqDarkGrey = Color(0xFF777777);
const Color spqDarkGreyTranslucent = Color(0x77777777);
const Color spqBlack = Color(0xFF080808);
const Color spqLightBlack = Color(0x42000000);
const Color spqBlackTranslucent = Color(0x77080808);
//endregion

//region Text
final TextTheme spqTextTheme = GoogleFonts.poppinsTextTheme();
//endregion

//region Themes
final ThemeData spqLightTheme = ThemeData(
    primarySwatch: Colors.blue,
    appBarTheme: const AppBarTheme(foregroundColor: spqBlack, backgroundColor: spqWhite),
    scaffoldBackgroundColor: spqWhite,
    backgroundColor: spqBackgroundGrey,
    bottomAppBarColor: spqWhite,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: spqWhite, selectedItemColor: spqPrimaryBlue, unselectedItemColor: spqDarkGrey),
    dialogBackgroundColor: spqWhite,
    primaryColor: spqPrimaryBlue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    errorColor: spqErrorRed,
    shadowColor: spqLightGreyTranslucent,
    //MOCKUP-Font (POPPINS) as default font.
    textTheme: spqTextTheme);

final ThemeData spqDarkTheme = ThemeData(
    primarySwatch: Colors.blue,
    appBarTheme: const AppBarTheme(foregroundColor: spqBlack, backgroundColor: spqWhite),
    scaffoldBackgroundColor: spqWhite,
    backgroundColor: spqBackgroundGrey,
    bottomAppBarColor: spqWhite,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: spqWhite, selectedItemColor: spqPrimaryBlue, unselectedItemColor: spqDarkGrey),
    dialogBackgroundColor: spqWhite,
    primaryColor: spqPrimaryBlue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    errorColor: spqErrorRed,
    shadowColor: spqLightGreyTranslucent,
    //MOCKUP-Font (POPPINS) as default font.
    textTheme: spqTextTheme);
//endregion
