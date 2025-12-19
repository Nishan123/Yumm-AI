import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/core/styles/container_property.dart';
import 'package:yumm_ai/screens/cooking/widgets/recipe_info_card.dart';
import 'package:yumm_ai/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/widgets/read_more_widget.dart';

class RecipeDetailsWidget extends StatefulWidget {
  const RecipeDetailsWidget({super.key});

  @override
  State<RecipeDetailsWidget> createState() => _RecipeDetailsWidgetState();
}

class _RecipeDetailsWidgetState extends State<RecipeDetailsWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 14, left: 16, right: 16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [ContainerProperty.darkerShadow],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.62,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "AI Generated Recipe Title or Name",
              style: AppTextStyles.h2.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
            SizedBox(height: 6),
            ReadMoreWidget(
              text:
                  "Savor the zest of hot chicken legs enhanced with a citrus shower of lemon, combining spicy warmth with a refreshing tang. Short description of the Food with some rich  laskdl lkas dlaks d history of origin of the food kdsnjfk sdkfj sa flkasd kla slkdc sald c.jkas dkcs kldj ",
              trimLine: 3,
            ),
            RecipeInfoCard(),
            CustomTabBar(
              externalController: _tabController,
              tabItems: ["Ingredients", "Instructions", "Tools"],
              margin: EdgeInsets.symmetric(horizontal: 0),
              itemTextStyle: AppTextStyles.descriptionText.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
              onTabChanged: (value) {},
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Text("Ingredients list"),
                  Text("Instructions list"),
                  Text("Kitchen Tools"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
