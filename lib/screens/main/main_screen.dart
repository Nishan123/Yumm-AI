import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/screens/cookbook/cookbook_screen.dart';
import 'package:yumm_ai/screens/home/home_screen.dart';
import 'package:yumm_ai/screens/item/item_screen.dart';
import 'package:yumm_ai/screens/main/widgets/custom_buttom_nav.dart';
import 'package:yumm_ai/screens/main/widgets/custom_fab.dart';
import 'package:yumm_ai/screens/setting/setting_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  final screens = const [
    HomeScreen(),
    ItemScreen(),
    CookbookScreen(),
    SettingScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CustomFab(
        onTap: () {
          context.pushNamed("pantryChef");
        },
      ),
      extendBody: true,

      body: Stack(
        children: [
          screens[selectedIndex],
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomButtomNav(
              currentIndex: selectedIndex,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
