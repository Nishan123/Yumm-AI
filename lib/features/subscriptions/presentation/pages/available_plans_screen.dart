import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/custom_text_button.dart';
import 'package:yumm_ai/core/widgets/primary_button.dart';
import 'package:yumm_ai/features/subscriptions/presentation/widgets/deals_card.dart';

class AvailablePlansScreen extends StatefulWidget {
  const AvailablePlansScreen({super.key});

  @override
  State<AvailablePlansScreen> createState() => _AvailablePlansScreenState();
}

class _AvailablePlansScreenState extends State<AvailablePlansScreen> {
  String _selectedPlans = "";
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 6,
              children: [
                Icon(LucideIcons.rocket, size: 36),
                Text(
                  "Free for first 7 days !",
                  style: AppTextStyles.h1.copyWith(color: AppColors.grayColor),
                ),
              ],
            ),
            Text(
              "Unlock the full experience\nand level up your cooking game.",
              style: AppTextStyles.h5.copyWith(height: 1.4),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            DealsCard(
              onTap: () {
                setState(() {
                  _selectedPlans = "years";
                });
              },
              mq: mq,
              isSelected: _selectedPlans=="years",
              haveBestValueTag: true,
              actualPrice: 29.99,
              oldPrice: 35.88,
              duration: "year",
            ),
            SizedBox(height: 8),
            DealsCard(
              onTap: () {
                setState(() {
                  _selectedPlans = "months";
                });
              },
              mq: mq,
              isSelected: _selectedPlans=="months",
              haveBestValueTag: false,
              actualPrice: 2.99,
              oldPrice: 0,
              duration: "month",
              haveOldPrice: false,
            ),
            SizedBox(height: 30),
            PrimaryButton(
              margin: EdgeInsets.symmetric(horizontal: 12),
              text: "Upgrade to Pro",
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Billing starts at the end of your free trial. Starting on 17/06/2024 you will be billed 29.99 every year until you cancel. You can cancel anytime in the Google Play Store",
                textAlign: TextAlign.center,
                style: AppTextStyles.descriptionText.copyWith(fontSize: 12),
              ),
            ),
            CustomTextButton(text: "Terms & Conditions", onTap: () {}),

            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
