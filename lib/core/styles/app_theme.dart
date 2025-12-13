import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';

ThemeData getAppTheme() {
  return ThemeData(
    fontFamily: "Poppins",
    appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: AppTextStyles.title.copyWith(color: AppColors.blackColor),
    ),
  );
}
