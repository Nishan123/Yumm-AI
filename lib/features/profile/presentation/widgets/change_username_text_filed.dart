import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class ChangeUsernameTextFiled extends StatelessWidget {
  final TextEditingController userNameController;
  const ChangeUsernameTextFiled({super.key, required this.userNameController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: userNameController,
      decoration: InputDecoration(
        hintText: "Username",
        isDense: false,
        contentPadding: const EdgeInsets.only(top: 8),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(LucideIcons.pen_line, size: 20),
        ),
        suffixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
      ),
    );
  }
}
