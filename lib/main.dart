import 'package:flutter/material.dart';
import 'package:yumm_ai/core/routing/app_routes.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppRoutes routingConfig = AppRoutes();
    return MaterialApp.router(
      title: "YummAI",
      theme: ThemeData(
        fontFamily: "Poppins",
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: AppTextStyles.title.copyWith(color: AppColors.blackColor,),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routeInformationParser: routingConfig.appRoutes.routeInformationParser,
      routeInformationProvider: routingConfig.appRoutes.routeInformationProvider,
      routerDelegate: routingConfig.appRoutes.routerDelegate,
    );
  }
}
