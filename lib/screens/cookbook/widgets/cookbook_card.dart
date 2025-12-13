import 'package:flutter/material.dart';
import 'package:yumm_ai/core/consts/constants.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/core/styles/container_property.dart';
import 'package:yumm_ai/widgets/dot.dart';
import 'package:yumm_ai/widgets/secondary_button.dart';

class CookbookCard extends StatelessWidget {
  final Key dismissibleKey;
  const CookbookCard({super.key, required this.dismissibleKey});

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Dismissible(
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete Recipe'),
              content: Text('Are you sure you want to delete this recipe?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      background: Container(
        margin: EdgeInsets.only(bottom: 24),
        padding: EdgeInsets.only(right: 30),
        color: AppColors.redColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.5),
            Icon(Icons.delete, color: Colors.white, size: 32),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      key: dismissibleKey,
      direction: DismissDirection.endToStart,
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 4),
        margin: EdgeInsets.only(left: 18, right: 18, bottom: 24),
        height: mq.height * 0.25,
        width: mq.width,
        decoration: BoxDecoration(
          color: AppColors.extraLightBlackColor,
          border: ContainerProperty.mainBorder,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [ContainerProperty.mainShadow],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              spacing: 8,
              children: [
                // Image Container
                Expanded(
                  flex: 3,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 2,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(16),
                        child: Image.asset(
                          "${Constants.assetImage}/salad.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                // Information Column
                Expanded(
                  flex: 6,
                  child: Column(
                    spacing: 3,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recipe name",
                        style: AppTextStyles.title.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Egg, Chicken and regular salad combo",
                        style: AppTextStyles.normalText.copyWith(
                          color: AppColors.descriptionTextColor,
                        ),
                      ),
                      Row(
                        spacing: 6,
                        children: [
                          Flexible(
                            child: Text(
                              "Can Cook",
                              style: AppTextStyles.normalText.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          dot(),
                          Flexible(
                            child: Text(
                              "45 min read",
                              style: AppTextStyles.normalText.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 6,
                        children: [
                          dot(),
                          Flexible(
                            child: Text(
                              "Recipe Included",
                              style: AppTextStyles.normalText.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.redColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Spacer(),
            SecondaryButton(
              margin: EdgeInsets.symmetric(horizontal: 0),
              haveHatIcon: true,
              borderRadius: 40,
              backgroundColor: AppColors.blackColor,
              onTap: () {},
              text: "Start Cooking",
            ),
          ],
        ),
      ),
    );
  }
}
