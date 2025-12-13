import 'package:flutter/material.dart';

class SecondaryIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const SecondaryIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap, child: Icon(icon));
  }
}
