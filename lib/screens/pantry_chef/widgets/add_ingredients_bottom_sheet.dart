import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/widgets/input_widget_title.dart';
import 'package:yumm_ai/widgets/primary_tex_field.dart';

class AddIngredientsBottomSheet extends StatefulWidget {
  const AddIngredientsBottomSheet({super.key});

  @override
  State<AddIngredientsBottomSheet> createState() =>
      _AddIngredientsBottomSheetState();
}

class _AddIngredientsBottomSheetState extends State<AddIngredientsBottomSheet> {
  final TextEditingController searchIngredientController =
      TextEditingController();
  final bool isSelected = false;
  final List<Map<String, dynamic>> ingreidents = [
    {
      "ingredientName": "Tomato",
      "prefixImage": "https://cdn-icons-png.flaticon.com/512/1790/1790387.png",
      "id": "ing001",
    },
    {
      "ingredientName": "Egg",
      "prefixImage": "https://cdn-icons-png.flaticon.com/512/837/837560.png",
      "id": "ing002",
    },
    {
      "ingredientName": "Milk",
      "prefixImage": "https://cdn-icons-png.flaticon.com/128/869/869869.png",
      "id": "ing003",
    },
    {
      "ingredientName": "Butter",
      "prefixImage": "https://cdn-icons-png.flaticon.com/128/3050/3050158.png",
      "id": "ing004",
    },
  ];
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 4, left: 16, right: 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(thickness: 4, indent: 120, endIndent: 120),
          InputWidgetTitle(
            title: "Add available ingredients",
            padding: EdgeInsets.only(left: 0, top: 8, bottom: 8),
          ),
          PrimaryTexField(
            hintText: 'Search: egg',
            controller: searchIngredientController,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ingreidents.length,
              itemBuilder: (context, index) {
                final data = ingreidents[index];
                return Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.only(left: 12, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.lightBlackColor,
                  ),
                  width: mq.width,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 36,
                        width: 36,
                        child: CachedNetworkImage(
                          imageUrl: data["prefixImage"],
                        ),
                      ),
                      SizedBox(width: 6,),
                      Text(data["ingredientName"]),
                      Spacer(),
                      Checkbox(value: isSelected, onChanged: (value) {}),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
