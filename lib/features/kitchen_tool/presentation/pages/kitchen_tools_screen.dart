import 'package:flutter/material.dart';

class KitchenToolsScreen extends StatelessWidget {
  const KitchenToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: Center(child: Text("Kitchen tools screen"))),
    );
  }
}