import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/core/consts/constants.dart';
import 'package:yumm_ai/screens/chefs/widgets/chef_card_widget.dart';
import 'package:yumm_ai/widgets/premium_ad_banner.dart';

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
              backgroundImage: "${Constants.assetSvg}/ad_banner2.svg",
              onTap: () {},
              buttonText: "Go Premium",
            ),
            ChefCardWidget(
              isLocked: false,
              suffixImage: Constants.fridgeScannerSuffix,
              backgroundImage: Constants.fridgeScannerBackground,
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
              suffixImage: Constants.receiptScannerSuffix,
              backgroundImage: Constants.receiptScannerBackground,
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
              suffixImage: Constants.pantryChefSuffix,
              backgroundImage: Constants.pantryChefBackground,
              onTap: () {
                context.pushNamed("pantryChef");
              },
              title: "Pantry Chef",
              description:
                  "Generate recipes based on the ingredients in you pantry.",
            ),
            ChefCardWidget(
              isLocked: true,
              isSuffixCropped: true,
              suffixImage: Constants.masterChefSuffix,
              backgroundImage: Constants.masterChefBackground,
              onTap: () {},
              title: "Master Chef",
              description:
                  "Generate personalized recipes to suite your carvings and dietary needs",
            ),
            ChefCardWidget(
              isLocked: true,
              suffixImage: Constants.macroChefSuffix,
              backgroundImage: Constants.macroChefBackground,
              onTap: () {},
              title: "Macro Chef",
              description:
                  "Create recipes tailored to your nutrients targets and dietary limits",
            ),
            ChefCardWidget(
              isLocked: true,
              suffixImage: Constants.pairPerfectSuffix,
              backgroundImage: Constants.pairPerfectBackground,
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
