import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData.light().copyWith(
        primaryColor: AppColors.primaryColor,
        textTheme: GoogleFonts.montserratTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          brightness: Brightness.light,
          primary: AppColors.primaryColor,
          secondary: AppColors.primaryColor,
        ));
  }

  static ThemeData darkTheme() {
    return ThemeData.dark();
  }
}
