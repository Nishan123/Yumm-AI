 import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';

Widget dot() {
    return Container(
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.blackColor,
      ),
    );
  }
