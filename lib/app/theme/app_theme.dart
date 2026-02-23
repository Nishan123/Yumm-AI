import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';

ThemeData getLightTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 0, 193, 6),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    fontFamily: "Poppins",
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
      titleTextStyle: AppTextStyles.title.copyWith(
        color: const Color.fromARGB(255, 0, 0, 0),
      ),
    ),
  );
}

ThemeData getDarkTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 0, 193, 6),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
    fontFamily: "Poppins",
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
      titleTextStyle: AppTextStyles.title.copyWith(
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
    ),
  );
}

ThemeData getSystemTheme() {
  return ThemeData();
}
