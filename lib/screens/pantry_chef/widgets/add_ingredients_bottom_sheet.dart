// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/models/ingredients_model.dart';
import 'package:yumm_ai/providers/get_ingredients_provider.dart';
import 'package:yumm_ai/widgets/input_widget_title.dart';
import 'package:yumm_ai/widgets/primary_tex_field.dart';

class AddIngredientsBottomSheet extends StatefulWidget {
  final List<IngredientsModel> selectedIngredients;
  final ValueChanged<List<IngredientsModel>> onSubmit;
  const AddIngredientsBottomSheet({
    super.key,
    required this.selectedIngredients,
    required this.onSubmit,
  });

  @override
  State<AddIngredientsBottomSheet> createState() =>
      _AddIngredientsBottomSheetState();
}

class _AddIngredientsBottomSheetState extends State<AddIngredientsBottomSheet> {
  final TextEditingController searchIngredientController =
      TextEditingController();
  String query = "";
  late Set<String> _selectedIds;
  List<IngredientsModel> _ingredients = [];
  @override
  void initState() {
    super.initState();
    _selectedIds = widget.selectedIngredients.map((e) => e.id).toSet();
  }

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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(thickness: 4, indent: 120, endIndent: 120),
          InputWidgetTitle(
            onActionTap: () {
              widget.onSubmit(
                _ingredients
                    .where((ing) => _selectedIds.contains(ing.id))
                    .toList(),
              );
              Navigator.of(context).pop();
            },
            haveActionButton: true,
            actionButtonText: "Done",
            title: "Add available ingredients",
            padding: EdgeInsets.only(left: 0, top: 8, bottom: 8),
          ),

          // search text field
          PrimaryTexField(
            hintText: 'Search: egg',
            controller: searchIngredientController,
            onChange: (value) {
              setState(() {
                query = value.trim();
              });
            },
          ),

          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: mq.height * 0.4),
              child: Consumer(
                builder: (context, ref, child) {
                  final ingredientsAsnc = ref.watch(getIngredientsProvider);
                  return ingredientsAsnc.when(
                    data: (ingredient) {
                      _ingredients = ingredient;
                      final filtered = query.isEmpty
                          ? ingredient
                          : ingredient
                                .where(
                                  (ing) => ing.ingredientName
                                      .toLowerCase()
                                      .contains(query.toLowerCase()),
                                )
                                .toList();
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final data = filtered[index];
                          final isSelected = _selectedIds.contains(data.id);
                          return Container(
                            margin: EdgeInsets.only(top: 8),
                            padding: EdgeInsets.only(
                              left: 12,
                              top: 4,
                              bottom: 4,
                            ),
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
                                    errorWidget: (context, url, error) {
                                      return Text("N/A");
                                    },
                                    imageUrl: data.prefixImage,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  data.ingredientName,
                                  style: AppTextStyles.normalText.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Spacer(),
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      if (isSelected) {
                                        _selectedIds.remove(data.id);
                                      } else {
                                        _selectedIds.add(data.id);
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    error: (error, stack) {
                      return Center(
                        child: Text("Failed to load ingredient $error"),
                      );
                    },
                    loading: () {
                      return Center(child: CircularProgressIndicator());
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
