import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';

ThemeData getLightTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.whiteColor,
    fontFamily: "Poppins",
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColors.blackColor),
      titleTextStyle: AppTextStyles.title.copyWith(color: AppColors.blackColor),
    ),
  );
}

ThemeData getDarkTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blackColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.blackColor,
    fontFamily: "Poppins",
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColors.whiteColor),
      titleTextStyle: AppTextStyles.title.copyWith(color: AppColors.whiteColor),
    ),
  );
}

ThemeData getSystemTheme() {
  return ThemeData();
}
