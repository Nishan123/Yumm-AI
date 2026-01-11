import 'package:flutter/material.dart';

class PantryInventoryScreen extends StatelessWidget {
  const PantryInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: Center(child: Text("Pantry Inventory screen"))),
    );
  }
}