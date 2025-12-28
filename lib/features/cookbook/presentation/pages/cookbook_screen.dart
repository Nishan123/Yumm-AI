import 'package:flutter/material.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/widgets/premium_ad_banner.dart';
import 'package:yumm_ai/features/cookbook/presentation/widgets/cookbook_card.dart';

class CookbookScreen extends StatefulWidget {
  const CookbookScreen({super.key});

  @override
  State<CookbookScreen> createState() => _CookbookScreenState();
}

class _CookbookScreenState extends State<CookbookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Cookbook")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(),
              const SizedBox(height: 18),
              PremiumAdBanner(
                text: "Store\nUnlimited Meals",
                backgroundImage: "${ConstantsString.assetSvg}/ad_banner2.svg",
                onTap: () {},
                buttonText: "Go Premium",
              ),
              SizedBox(height: 18,),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 12,
                itemBuilder: (context, index) {
                  return CookbookCard(
                    dismissibleKey: ValueKey('recipe_$index'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
