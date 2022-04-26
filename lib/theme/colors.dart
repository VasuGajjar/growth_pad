import 'package:flutter/cupertino.dart';

class AppColors {
  static bool lightTheme = false;

  static const Color green = Color(0xFF19A463);
  static const Color gray = Color(0xFF464E5B);
  static const Color darkGray = Color(0xFF363E4B);
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF1F1F1);
  static const Color black = Color(0xFF000000);
  static const Color red = Color(0xFFFF4D4F);
  static const Color orange = Color(0xFFFAAD14);
  static const Color blue = Color(0xFF1890FF);

  static const Color primaryColor = green;
  static const Color onPrimaryColor = white;
  static const Color secondaryColor = darkGray;

  static Color get onSecondaryColor => lightTheme ? darkGray : offWhite;

  static Color get cardColor => lightTheme ? white : gray;

  static Color get backgroundColor => lightTheme ? offWhite : darkGray;

  static Color get textColor => lightTheme ? black : offWhite;

  static Color get appBarColor => lightTheme ? green : gray;

  static const Color errorColor = red;
  static const Color warningColor = orange;
  static const Color infoColor = blue;
  static const Color successColor = green;
}
