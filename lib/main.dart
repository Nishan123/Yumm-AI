import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/screens/main/main_screen.dart';
import 'package:yumm_ai/screens/scanner/scanner_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Poppins",
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: AppTextStyles.title.copyWith(color: AppColors.blackColor,),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: ScannerScreen(),
    );
  }
}
