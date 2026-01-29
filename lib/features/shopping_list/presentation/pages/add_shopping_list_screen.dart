import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/core/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/core/widgets/custom_drop_down.dart';
import 'package:yumm_ai/core/widgets/primary_text_field.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/presentation/providers/get_ingredients_provider.dart';
import 'package:yumm_ai/features/shopping_list/presentation/enums/item_unit.dart';
import 'package:yumm_ai/features/shopping_list/presentation/enums/shopping_list_type.dart';

class AddShoppingListScreen extends ConsumerStatefulWidget {
  const AddShoppingListScreen({super.key});

  @override
  ConsumerState<AddShoppingListScreen> createState() =>
      _AddShoppingListScreenState();
}

class _AddShoppingListScreenState extends ConsumerState<AddShoppingListScreen> {
  ShoppingListType _itemType = ShoppingListType.any;
  String _selectedUnit = "";
  final itemController = TextEditingController();
  final quantityController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  List<IngredientModel> _ingredients = [];
  List<IngredientModel> _filteredIngredients = [];
  bool _isLoadingIngredients = false;
  String? _ingredientsError;
  String _query = "";
  String? _selectedIngredientId;

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    setState(() {
      _isLoadingIngredients = true;
      _ingredientsError = null;
    });
    try {
      final items = await ref.read(getIngredientsProvider.future);
      if (!mounted) return;
      setState(() {
        _ingredients = items;
        _filteredIngredients = items;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _ingredientsError = "Failed to load ingredients: $error";
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingIngredients = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _query = value.trim();
      _selectedIngredientId = null;
      _filteredIngredients = _query.isEmpty
          ? _ingredients
          : _ingredients
                .where(
                  (item) =>
                      item.name.toLowerCase().contains(_query.toLowerCase()),
                )
                .toList();
    });
  }

  void _selectIngredient(IngredientModel item) {
    setState(() {
      _selectedIngredientId = item.ingredientId;
      itemController.text = item.name;
      _query = item.name;
      _filteredIngredients = [item];
    });
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    itemController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Shopping List")),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constrains) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constrains.maxHeight),
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12,
                    children: [
                      PrimaryTextField(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        defaultBorderColor: AppColors.lightBlackColor,
                        hintText: "Search Item (example: tomato)",
                        controller: itemController,
                        onChange: _onSearchChanged,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Item is empty !";
                          } else {
                            return null;
                          }
                        },
                      ),

                      if (_isLoadingIngredients)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                          ),
                        )
                      else if (_ingredientsError != null)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _ingredientsError!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        )
                      else if (_query.isNotEmpty &&
                          _filteredIngredients.isNotEmpty &&
                          _selectedIngredientId == null)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            constraints: BoxConstraints(maxHeight: 220),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              border: Border.all(
                                color: AppColors.lightBlackColor,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: _filteredIngredients.length,
                              separatorBuilder: (_, __) => Divider(height: 1),
                              itemBuilder: (context, index) {
                                final item = _filteredIngredients[index];
                                final isSelected =
                                    item.ingredientId == _selectedIngredientId;
                                return ListTile(
                                  leading: item.imageUrl.isNotEmpty
                                      ? CachedNetworkImage(
                                          height: 30,
                                          width: 30,
                                          imageUrl: item.imageUrl,
                                          errorWidget: (context, url, error) {
                                            return Icon(
                                              Icons.error,
                                              color: AppColors.redColor,
                                              size: 28,
                                            );
                                          },
                                        )
                                      : SizedBox(height: 30, width: 30),
                                  title: Text(item.name),
                                  trailing: isSelected
                                      ? Icon(
                                          Icons.check,
                                          color: AppColors.primaryColor,
                                        )
                                      : null,
                                  onTap: () => _selectIngredient(item),
                                );
                              },
                            ),
                          ),
                        ),

                      CustomDropDown(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Unit not selected !";
                          } else {
                            return null;
                          }
                        },
                        title: "Unit (example: Kg)",
                        options: ItemUnit.values
                            .map((e) => e.text.toString())
                            .toList(),
                        selectedOptions: _selectedUnit,
                        onConfirm: (value) {
                          setState(() {
                            _selectedUnit = value;
                          });
                        },
                      ),

                      PrimaryTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Quantity is empty !";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        defaultBorderColor: AppColors.lightBlackColor,
                        hintText: "Qty (example: 3)",
                        controller: quantityController,
                      ),

                      CustomChoiceChip(
                        onSelected: (value) {
                          setState(() {
                            _itemType = value;
                            debugPrint(_itemType.value);
                          });
                        },
                        values: ShoppingListType.values,
                        labelBuilder: (item) => item.text,
                        iconBuilder: (item) => null,
                      ),
                      SizedBox(height: 12),
                      SecondaryButton(
                        borderRadius: 40,
                        backgroundColor: AppColors.blackColor,
                        onTap: () {
                          if (!_form.currentState!.validate()) return;

                          debugPrint(
                            "${itemController.text}, $_selectedIngredientId, $_selectedUnit, ${quantityController.text}, ${_itemType.value}",
                          );
                        },
                        text: "Add Item",
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
