import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/input_widget_title.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/core/widgets/secondary_icon_button.dart';
import 'package:yumm_ai/features/chef/data/Ingrident_model.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/add_ingredients_bottom_sheet.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_wrap_container.dart';
import 'package:yumm_ai/features/profile/presentation/widgets/profile_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<IngredientModel> selectedIngredients = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: 20),
              ProfileCard(),
              SizedBox(height: 20),
              InputWidgetTitle(
                title: "You are allergic to :",
                padding: EdgeInsets.symmetric(horizontal: 0),
                onActionTap: () {},
              ),
              SizedBox(height: 12),
              // allergic items container
              IngredientsWrapContainer(
                haveAddIngredientButton: true,
                onAddIngredientButtonPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return AddIngredientsBottomSheet(
                        title: "Search ingredients",
                        selectedIngredients: selectedIngredients,
                        onSubmit: (List<IngredientModel> newSelection) {
                          setState(() {
                            selectedIngredients = newSelection;
                          });
                        },
                      );
                    },
                  );
                },
                emptyText: "No Allergic Ingredients",
                margin: EdgeInsets.all(0),
                items: selectedIngredients
                    .map(
                      (ing) => AllergicItemChips(
                        onTap: () {
                          setState(() {
                            selectedIngredients.removeWhere(
                              (item) => item.id == ing.id,
                            );
                          });
                        },
                        text: ing.ingredientName,
                      ),
                    )
                    .toList(),
              ),
              Spacer(),
              SecondaryButton(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                borderRadius: 40,
                backgroundColor: AppColors.lightBlueColor,
                onTap: null,
                text: "Update Profile",
              ),
              SecondaryButton(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                borderRadius: 40,
                backgroundColor: AppColors.redColor,
                onTap: () {},
                text: "Log Out",
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class AllergicItemChips extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const AllergicItemChips({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 6, top: 6, bottom: 6),
      margin: EdgeInsets.only(right: 10, top: 5, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.redColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        spacing: 3,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: AppTextStyles.normalText.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SecondaryIconButton(icon: LucideIcons.circle_x, onTap: onTap, iconColor: AppColors.whiteColor,),
        ],
      ),
    );
  }
}
