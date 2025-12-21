import 'dart:math';
import 'package:flutter/material.dart';
import 'package:yumm_ai/models/ingredients_model.dart';
import 'package:yumm_ai/screens/cooking/widgets/ingredients_list_tile.dart';

class IngredientList extends StatelessWidget {
  const IngredientList({super.key});

  Color _colorForIndex(int index) {
    final rnd = Random(index * 9973);
    final r = rnd.nextInt(256);
    final g = rnd.nextInt(256);
    final b = rnd.nextInt(256);
    return Color.fromARGB(77, r, g, b);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, left: 16),
      child: SizedBox(
        height: 140,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 20,
          primary: false,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return IngredientsListTile(
              bgColor: _colorForIndex(index),
              ingredient: IngredientsModel(
                id: "32",
                prefixImage:
                    "https://www.themealdb.com/images/ingredients/Tomato.png",
                ingredientName: "Tomato",
              ),
              quantity: "x3",
            );
          },
        ),
      ),
    );
  }
}
