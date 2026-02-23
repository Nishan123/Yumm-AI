import 'package:flutter/material.dart';

class AppColors {
  static ThemeMode? currentThemeMode;

  static bool get isDarkMode {
    if (currentThemeMode == ThemeMode.dark) return true;
    if (currentThemeMode == ThemeMode.light) return false;
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  static Color  lightPrimaryColor = const Color.fromARGB(255, 84, 225, 88);

  static Color  primaryColor = const Color.fromARGB(255, 0, 193, 6);

  static Color get blackColor => isDarkMode
      ? const Color.fromARGB(255, 255, 255, 255)
      : const Color.fromARGB(255, 0, 0, 0);

  static Color get descriptionTextColor => isDarkMode
      ? const Color.fromARGB(255, 180, 180, 180)
      : const Color.fromARGB(255, 121, 121, 121);
      
  static Color get lightBlackColor => isDarkMode
      ? const Color.fromRGBO(255, 255, 255, 0.071)
      : const Color.fromARGB(18, 91, 91, 91);

  static Color get extraLightBlackColor => isDarkMode
      ? const Color.fromARGB(255, 50, 50, 50)
      : const Color.fromARGB(255, 223, 223, 223);

  static Color get shadowColor => isDarkMode
      ? const Color.fromARGB(60, 255, 255, 255)
      : const Color.fromARGB(60, 0, 0, 0);

  static Color get darkerShadowColor => isDarkMode
      ? const Color.fromARGB(80, 255, 255, 255)
      : const Color.fromARGB(80, 0, 0, 0);
      
  static Color get whiteShadowColor => isDarkMode
      ? const Color.fromARGB(255, 50, 100, 50)
      : const Color.fromARGB(255, 186, 255, 175);
  static Color get lightWhiteColor => isDarkMode
      ? const Color.fromARGB(60, 0, 0, 0)
      : const Color.fromARGB(60, 255, 255, 255);
  static Color get whiteColor => isDarkMode
      ? const Color.fromARGB(255, 18, 18, 18)
      : const Color.fromARGB(255, 255, 255, 255);
  static Color get normalIconColor => isDarkMode
      ? const Color.fromARGB(180, 255, 255, 255)
      : const Color.fromARGB(80, 0, 0, 0);
  static Color get blueColor => isDarkMode
      ? const Color.fromARGB(255, 100, 50, 200)
      : const Color.fromARGB(255, 73, 0, 162);
  static Color get lightBlueColor => isDarkMode
      ? const Color.fromARGB(255, 120, 70, 220)
      : const Color.fromARGB(255, 83, 20, 159);
  static Color get redColor => isDarkMode
      ? const Color.fromARGB(255, 255, 80, 80)
      : const Color.fromARGB(255, 228, 0, 19);
  static Color get borderColor => isDarkMode
      ? const Color.fromARGB(255, 60, 60, 60)
      : const Color.fromARGB(255, 211, 211, 211);
  static Color get grayColor => isDarkMode
      ? const Color.fromARGB(255, 0, 200, 80)
      : const Color.fromARGB(255, 0, 151, 53);
  static Color get skeletonBaseColor => isDarkMode
      ? const Color.fromARGB(255, 40, 40, 40)
      : const Color.fromARGB(255, 219, 219, 219);
  static Color get skeletonHighlightColor => isDarkMode
      ? const Color.fromARGB(255, 60, 60, 60)
      : const Color.fromARGB(255, 243, 243, 243);
}
