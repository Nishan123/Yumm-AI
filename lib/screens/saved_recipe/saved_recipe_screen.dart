import 'package:flutter/material.dart';

class SavedRecipeScreen extends StatelessWidget {
  const SavedRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: Center(child: Text("Saved Recipe screen"))),
    );
  }
}
