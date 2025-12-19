import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:yumm_ai/core/routing/app_routes.dart';
import 'package:yumm_ai/core/styles/app_theme.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  Gemini.init(apiKey: dotenv.get("gemini_api_key"));
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppRoutes routingConfig = AppRoutes();
    return MaterialApp.router(
      title: "YummAI",
      theme: getAppTheme(),
      debugShowCheckedModeBanner: false,
      routeInformationParser: routingConfig.appRoutes.routeInformationParser,
      routeInformationProvider:
          routingConfig.appRoutes.routeInformationProvider,
      routerDelegate: routingConfig.appRoutes.routerDelegate,
    );
  }
}
