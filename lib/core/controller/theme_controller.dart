import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController implements GetxService {
  SharedPreferences preferences;

  ThemeController({required this.preferences});

  bool isLightTheme() {
    bool lightTheme = preferences.getBool(Constant.spTheme) ?? AppColors.lightTheme;
    AppColors.lightTheme = lightTheme;
    return lightTheme;
  }

  Future<void> changeTheme() async {
    bool lightTheme = !AppColors.lightTheme;
    await preferences.setBool(Constant.spTheme, lightTheme);
    AppColors.lightTheme = lightTheme;
    // update();
  }

  ThemeData getTheme() => isLightTheme() ? lightTheme() : darkTheme();

  static ThemeData lightTheme() {
    return ThemeData.light().copyWith(
        primaryColor: AppColors.primaryColor,
        textTheme: GoogleFonts.montserratTextTheme(),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          brightness: Brightness.light,
          primary: AppColors.primaryColor,
          secondary: AppColors.primaryColor,
        ));
  }

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
        primaryColor: AppColors.primaryColor,
        textTheme: GoogleFonts.montserratTextTheme(),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(foregroundColor: AppColors.offWhite),
        appBarTheme: AppBarTheme(backgroundColor: AppColors.appBarColor),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          brightness: Brightness.dark,
          primary: AppColors.primaryColor,
          secondary: AppColors.primaryColor,
          onPrimary: AppColors.onPrimaryColor,
        ));
  }

  static Future<ThemeController> getInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return ThemeController(preferences: preferences);
  }
}
