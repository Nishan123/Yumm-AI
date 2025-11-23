import 'package:flutter/material.dart';
import 'package:yumm_ai/screens/home/widgets/home_app_bar.dart';
import 'package:yumm_ai/screens/home/widgets/home_search_bar.dart';
import 'package:yumm_ai/screens/home/widgets/welcome_text.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:HomeAppBar(),
      body: SafeArea(child: Column(
        children: [
          WelcomeText(),
          HomeSearchBar()
        ],
      )),
    );
  }
}
