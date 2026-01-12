import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/widgets/premium_ad_banner.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/chef_card_widget.dart';

class ChefsScreen extends StatelessWidget {
  const ChefsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select your desired chef")),
      body: SingleChildScrollView(
        child: Column(
          spacing: 18,
          children: [
            Divider(),
            PremiumAdBanner(
              text: "Unlock\nAll Chefs",
              backgroundImage: "${ConstantsString.assetSvg}/ad_banner2.svg",
              buttonText: "Go Premium",
            ),
            ChefCardWidget(
              isLocked: false,
              suffixImage: ConstantsString.fridgeScannerSuffix,
              backgroundImage: ConstantsString.fridgeScannerBackground,
              onTap: () {
                context.pushNamed(
                  "scanner",
                  queryParameters: {"selectedScanner": "fridgeScanner"},
                );
              },
              title: "Fridge Scanner",
              description:
                  "Scan inside your fridge to prepare the combination of available items ",
            ),
            ChefCardWidget(
              isLocked: false,
              suffixImage: ConstantsString.receiptScannerSuffix,
              backgroundImage: ConstantsString.receiptScannerBackground,
              onTap: () {
                context.pushNamed(
                  "scanner",
                  queryParameters: {"selectedScanner": "receiptScanner"},
                );
              },
              title: "Receipt Scanner",
              description: "Scan your ingredients receipt to prepare a meal",
            ),
            ChefCardWidget(
              isLocked: false,
              isSuffixCropped: true,
              suffixImage: ConstantsString.pantryChefSuffix,
              backgroundImage: ConstantsString.pantryChefBackground,
              onTap: () {
                context.pushNamed("pantry_chef");
              },
              title: "Pantry Chef",
              description:
                  "Generate recipes based on the ingredients in you pantry.",
            ),
            ChefCardWidget(
              isLocked: true,
              isSuffixCropped: true,
              suffixImage: ConstantsString.masterChefSuffix,
              backgroundImage: ConstantsString.masterChefBackground,
              onTap: () {
                context.pushNamed("master_chef");
              },
              title: "Master Chef",
              description:
                  "Generate personalized recipes to suite your carvings and dietary needs",
            ),
            ChefCardWidget(
              isLocked: true,
              suffixImage: ConstantsString.macroChefSuffix,
              backgroundImage: ConstantsString.macroChefBackground,
              onTap: () {
                context.pushNamed("macro_chef");
              },
              title: "Macro Chef",
              description:
                  "Create recipes tailored to your nutrients targets and dietary limits",
            ),
            ChefCardWidget(
              isLocked: true,
              suffixImage: ConstantsString.pairPerfectSuffix,
              backgroundImage: ConstantsString.pairPerfectBackground,
              onTap: () {},
              title: "Pair Perfect",
              description:
                  "Get prefect recommended wine or beer paring for your meal",
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
