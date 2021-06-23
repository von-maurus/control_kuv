import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class KuveColors {
  static final blue = Color(0xFF0D47A1);
  static final purple = Color(0xFF5117AC);
  static final amber = Color(0xFFFF8F00);
  static final white = Color(0xE8FFFFFF);
  static final pink = Color(0xFFF5638B);
  static final darkGrey = Color(0xFF212121);
  static final kuveMorado = Color(0xFF2D1663);
  static final kuveMoradoLessOp = Color(0x90693EC5);
  static final kuveVerde = Color(0xFF1EDA81);
  static final kuveVerdeMoreOp = Color(0xFB1BD47B);
  static final kuveVerdeLessOp = Color(0xDC59F1AF);

  static Icon backArrow(BuildContext context) {
    return Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
        size: 30.0, color: Theme.of(context).buttonColor);
  }
}

final gradient1 = [
  KuveColors.kuveMorado,
  KuveColors.kuveMorado,
  // KuveColors.kuveMorado,
  // KuveColors.kuveVerdeLessOp,
];

// final _borderLight = OutlineInputBorder(
//   borderRadius: BorderRadius.circular(10),
//   borderSide: BorderSide(
//     color: KuveColors.kuveVerde,
//     width: 2,
//     style: BorderStyle.solid,
//   ),
// );

final lightTheme = ThemeData(
  // primaryColor: KuveColors.kuveMorado,
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    bodyColor: KuveColors.white,
    decorationColor: KuveColors.kuveMorado,
    displayColor: KuveColors.kuveVerde,
  ),
  primarySwatch: Colors.deepPurple,
  dialogBackgroundColor: Colors.white,
  dialogTheme: DialogTheme(
    titleTextStyle: TextStyle(color: KuveColors.kuveMorado, fontSize: 18.0),
    contentTextStyle: TextStyle(color: KuveColors.kuveMorado, fontSize: 15.0),
  ),
  primaryIconTheme: IconThemeData(color: KuveColors.kuveMorado),
  // accentIconTheme: IconThemeData(color: Colors.grey),
  iconTheme: IconThemeData(color: Colors.grey),
  primaryColorBrightness: Brightness.light,
  backgroundColor: KuveColors.white,
  // accentColor: KuveColors.kuveMorado,
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: KuveColors.kuveVerde),
  canvasColor: KuveColors.white,
  brightness: Brightness.dark,
  hintColor: Colors.grey,
  inputDecorationTheme: InputDecorationTheme(
    focusColor: KuveColors.kuveVerdeLessOp,
    hintStyle: TextStyle(color: Colors.grey.shade100),
    helperStyle: TextStyle(color: Colors.grey),
    labelStyle: TextStyle(color: Colors.grey),
    prefixStyle: TextStyle(
      color: KuveColors.white,
    ),
  ),
  appBarTheme: AppBarTheme(
    backwardsCompatibility: true,
    backgroundColor: KuveColors.kuveMorado,
    titleTextStyle: TextStyle(color: KuveColors.white),
    toolbarTextStyle: TextStyle(color: KuveColors.white),
    iconTheme: IconThemeData(color: KuveColors.white),
    elevation: 6.0,
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle(
      systemNavigationBarColor: KuveColors.kuveMorado,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: KuveColors.kuveMorado,
    ),
    textTheme: TextTheme(
        headline6: TextStyle(
      color: KuveColors.white,
      fontSize: 25.0,
    )),
  ),
);

// final _borderDark = OutlineInputBorder(
//   borderRadius: BorderRadius.circular(10),
//   borderSide: BorderSide(
//     color: DeliveryColors.purple,
//     width: 2,
//     style: BorderStyle.solid,
//   ),
// );

// final darkTheme = ThemeData(
//   appBarTheme: AppBarTheme(
//     color: DeliveryColors.purple,
//     textTheme: GoogleFonts.poppinsTextTheme().copyWith(
//       headline6: TextStyle(
//         fontSize: 20,
//         color: DeliveryColors.white,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//   ),
//   bottomAppBarColor: Colors.transparent,
//   canvasColor: DeliveryColors.grey,
//   scaffoldBackgroundColor: DeliveryColors.dark,
//   accentColor: DeliveryColors.white,
//   textTheme: GoogleFonts.poppinsTextTheme().apply(
//     bodyColor: DeliveryColors.green,
//     displayColor: DeliveryColors.green,
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     border: _borderDark,
//     enabledBorder: _borderDark,
//     contentPadding: EdgeInsets.zero,
//     focusedBorder: _borderDark,
//     labelStyle: TextStyle(color: DeliveryColors.white),
//     fillColor: DeliveryColors.grey,
//     filled: true,
//     hintStyle: GoogleFonts.poppins(
//       color: DeliveryColors.white,
//       fontSize: 10,
//     ),
//   ),
//   iconTheme: IconThemeData(
//     color: DeliveryColors.white,
//   ),
// );
