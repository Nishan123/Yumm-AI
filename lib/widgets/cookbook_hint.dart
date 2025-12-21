import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';

class CookbookHint extends StatelessWidget {
  const CookbookHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),
      decoration: BoxDecoration( color: AppColors.lightPrimaryColor),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          Text("Generated meal is saved in your Cookbook",style: TextStyle(color: AppColors.whiteColor),),
          Icon(LucideIcons.chef_hat, size: 18,color: AppColors.whiteColor,),
        ],
      ),
    );
  }
}
