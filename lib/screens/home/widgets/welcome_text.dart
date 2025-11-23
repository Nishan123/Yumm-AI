import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        Text("Welcome Foody !",style: AppTextStyles.title,),
        SvgPicture.asset("assets/images/ai_star.svg",height: 26,width: 26,),
      ],
    );
  }
}
