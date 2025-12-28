import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool? isObscure;
  final VoidCallback? onShowPassword;
  final bool? isPassword;
  final IconData? suffixIcon;
  final IconData prefixIcon;
  final String? Function(String?) validator;
  final TextInputType? inputType;

  const AuthTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscure,
    this.onShowPassword,
    this.isPassword,
    this.suffixIcon,
    required this.prefixIcon,
    required this.validator,
     this.inputType
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType??TextInputType.name,
      validator: validator,
      obscureText: isObscure ?? false,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Icon(prefixIcon, color: AppColors.normalIconColor),
        ),
        contentPadding: EdgeInsets.only(top: 18, bottom: 18, left: 16),
        suffixIcon: isPassword ?? false
            ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: onShowPassword,
                  icon: Icon(suffixIcon, size: 23, color: AppColors.blackColor),
                ),
              )
            : null,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
