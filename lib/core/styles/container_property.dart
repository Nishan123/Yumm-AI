import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';

class ContainerProperty {
  static final BoxShadow mainShadow = BoxShadow(
    color: AppColors.shadowColor,
    spreadRadius: 1,
    blurRadius: 6,
  );
  static final BoxShadow miniShadow = BoxShadow(
    color: AppColors.shadowColor,
    spreadRadius: 0.5,
    blurRadius: 4,
  );
  static final Border mainBorder = Border.all(
    color: AppColors.whiteColor, width: 4
  );
  static final Border smallBorder = Border.all(
    color: AppColors.whiteColor, width: 2.6
  );
  static final BoxShadow navBarShadow = BoxShadow(
    color: AppColors.shadowColor,
    blurRadius: 20,
  );
}
