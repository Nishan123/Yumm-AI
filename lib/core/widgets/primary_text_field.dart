import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';

class PrimaryTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Color? focusedColor;
  final Color? defaultBorderColor;
  final Function(String)? onChange;
  final TextInputType? keyboardType;
  final EdgeInsets? margin;
  const PrimaryTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.focusedColor,
    this.defaultBorderColor,
    this.onChange,
    this.keyboardType,
    this.margin
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin??EdgeInsets.symmetric(horizontal: 0,vertical: 0),
      child: TextFormField(
        keyboardType: keyboardType ?? TextInputType.text,
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
      ),
    );
  }
}
