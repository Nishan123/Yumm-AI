import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class CookbookHint extends StatelessWidget {
  const CookbookHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 4,
      children: [
        Text("Generated meal is saved in your Cookbook"),
        Icon(LucideIcons.chef_hat, size: 18),
      ],
    );
  }
}
