import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

final gradient1 = [KuveColors.purple, KuveColors.blue];

// final _borderLight = OutlineInputBorder(
//   borderRadius: BorderRadius.circular(10),
//   borderSide: BorderSide(
//     color: KuveColors.kuveVerde,
//     width: 2,
//     style: BorderStyle.solid,
//   ),
// );

final lightTheme = ThemeData(
  backgroundColor: KuveColors.white,
  primarySwatch: Colors.purple,
  canvasColor: KuveColors.white,
  primaryIconTheme: IconThemeData(color: KuveColors.kuveMorado),
  primaryColorBrightness: Brightness.light,
  accentColorBrightness: Brightness.dark,
  bottomAppBarColor: KuveColors.purple,
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    bodyColor: KuveColors.kuveMorado,
    displayColor: KuveColors.kuveMorado,
  ),
  // inputDecorationTheme: InputDecorationTheme(
  //   border: _borderLight,
  //   enabledBorder: _borderLight,
  //   labelStyle: TextStyle(color: KuveColors.purple),
  //   focusedBorder: _borderLight,
  //   contentPadding: EdgeInsets.zero,
  //   hintStyle: GoogleFonts.poppins(
  //     color: KuveColors.purple,
  //     fontSize: 10,
  //   ),
  // ),
  // iconTheme: IconThemeData(
  //   color: KuveColors.purple,
  // ),
  // appBarTheme: AppBarTheme(
  //   color: KuveColors.blue,
  //   textTheme: GoogleFonts.poppinsTextTheme().copyWith(
  //     headline6: TextStyle(
  //       fontSize: 20,
  //       color: KuveColors.purple,
  //       fontWeight: FontWeight.bold,
  //     ),
  //   ),
  // ),
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
