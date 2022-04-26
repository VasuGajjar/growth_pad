import 'package:flutter/material.dart';

import 'colors.dart';

class TextStyles {
  static TextStyle get h1Bold => TextStyle(color: AppColors.textColor, fontSize: 22, fontWeight: FontWeight.bold);
  static TextStyle get h1Normal => TextStyle(color: AppColors.textColor, fontSize: 22, fontWeight: FontWeight.normal);

  static TextStyle get h2Bold => TextStyle(color: AppColors.textColor, fontSize: 20, fontWeight: FontWeight.bold);
  static TextStyle get h2Normal => TextStyle(color: AppColors.textColor, fontSize: 20, fontWeight: FontWeight.normal);

  static TextStyle get h3Bold => TextStyle(color: AppColors.textColor, fontSize: 18, fontWeight: FontWeight.bold);
  static TextStyle get h3Normal => TextStyle(color: AppColors.textColor, fontSize: 18, fontWeight: FontWeight.normal);

  static TextStyle get p1Bold => TextStyle(color: AppColors.textColor, fontSize: 16, fontWeight: FontWeight.bold);
  static TextStyle get p1Normal => TextStyle(color: AppColors.textColor, fontSize: 16, fontWeight: FontWeight.normal);

  static TextStyle get p2Bold => TextStyle(color: AppColors.textColor, fontSize: 14, fontWeight: FontWeight.bold);
  static TextStyle get p2Normal => TextStyle(color: AppColors.textColor, fontSize: 14, fontWeight: FontWeight.normal);

  static TextStyle get p3Bold => TextStyle(color: AppColors.textColor, fontSize: 12, fontWeight: FontWeight.bold);
  static TextStyle get p3Normal => TextStyle(color: AppColors.textColor, fontSize: 12, fontWeight: FontWeight.normal);
}
