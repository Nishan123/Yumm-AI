import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';

class PrimaryTexField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Color? focusedColor;
  final Color? defaultBorderColor;
  final Function(String)? onChange;
  const PrimaryTexField({
    super.key,
    required this.hintText,
    required this.controller,
    this.focusedColor,
    this.defaultBorderColor,
    this.onChange
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChange,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 4,
            color: focusedColor ?? AppColors.primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 3,
            color: defaultBorderColor ?? AppColors.lightPrimaryColor,
          ),
        ),
      ),
    );
  }
}
