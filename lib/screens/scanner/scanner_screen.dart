import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/widgets/secondary_button.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Scanner  "),
            Icon(LucideIcons.chef_hat, color: AppColors.primaryColor),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            //camera container
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: AppColors.extraLightBlackColor,
                border: Border.all(width: 4, color: AppColors.whiteColor),
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    spreadRadius: 1,
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            CustomChoiceChip(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SecondaryButton(
                borderRadius: 30,
                backgroundColor: AppColors.blackColor,
                onTap: () {},
                text: "Generate Recipe",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
