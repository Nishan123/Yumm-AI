import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/core/consts/constants.dart';
import 'package:yumm_ai/screens/item/widgets/item_card.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    // Calculate responsive cross axis count based on screen width
    int getCrossAxisCount() {
      if (mq.width > 1200) return 4; // Large screens
      if (mq.width > 800) return 3; // Medium screens
      return 2; // Small screens (default)
    }

    // Calculate responsive padding
    double getHorizontalPadding() {
      if (mq.width > 1200) return 40;
      if (mq.width > 800) return 30;
      return 20;
    }

    return Scaffold(
      appBar: AppBar(title: Text("Every Items")),
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 1200,
          ), // Max width for very large screens
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getHorizontalPadding(),
              vertical: 20,
            ),
            child: GridView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: getCrossAxisCount(),
                childAspectRatio: 0.78,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              children: [
                ItemCard(
                  onTap: () {
                    context.pushNamed("shopping_list");
                  },
                  mq: mq,
                  itemName: "Shopping List",
                  savedItems: 0,
                  image: "${Constants.assetImage}/shopping_list.png",
                ),
                ItemCard(
                  onTap: () {
                    context.pushNamed("pantry_inventory");
                  },
                  mq: mq,
                  itemName: "Pantry Inventory",
                  savedItems: 0,
                  image: "${Constants.assetImage}/pantry.png",
                ),
                ItemCard(
                  onTap: () {
                    context.pushNamed("kitchen_tools");
                  },
                  mq: mq,
                  itemName: "Kitchen Tools",
                  savedItems: 0,
                  image: "${Constants.assetImage}/pan.png",
                ),
                ItemCard(
                  onTap: () {
                    context.pushNamed("saved_recipe");
                  },
                  mq: mq,
                  itemName: "Saved Recipes",
                  savedItems: 0,
                  image: "${Constants.assetImage}/saved_recipe.png",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
