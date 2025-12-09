import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/widgets/svg_text_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 3),
    ).then((_) => context.goNamed("onboarding"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: SvgTextLogo()
        ),
      ),
    );
  }
}
