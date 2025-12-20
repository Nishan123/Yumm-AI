import 'package:flutter/material.dart';
import 'package:yumm_ai/models/ingredients_model.dart';
import 'package:yumm_ai/screens/cooking/widgets/ingredients_list_tile.dart';

class IngredientList extends StatelessWidget {
  const IngredientList({
    super.key,
    this.scrollController,
    this.isActive = true,
  });

  final ScrollController? scrollController;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      controller: isActive ? scrollController : null,
      physics: isActive
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return IngredientsListTile(
          ingredient: IngredientsModel(
            id: "32",
            prefixImage:
                "https://www.themealdb.com/images/ingredients/Tomato.png",
            ingredientName: "Tomato",
          ),
          quantity: "x3",
        );
      },
    );
  }
}
