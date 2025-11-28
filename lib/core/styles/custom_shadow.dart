import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';

class CustomShadow {
  static final BoxShadow mainShadow = BoxShadow(
    color: AppColors.shadowColor,
    spreadRadius: 1,
    blurRadius: 6,
  );
  static final BoxShadow navBarShadow = BoxShadow(
    color: AppColors.shadowColor,
    blurRadius: 20,
  );
}
