import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CircleAvatar(
        radius: 23,
        backgroundColor: AppColors.blackColor,
      ),
      actions: [
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle,color: AppColors.lightBlackColor),
          child: IconButton(onPressed: (){},icon: Icon(Icons.menu,color: AppColors.blackColor,),),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
