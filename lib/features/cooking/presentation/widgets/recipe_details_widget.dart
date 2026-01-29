import 'package:flutter/material.dart';

import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/core/widgets/read_more_widget.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/ingredient_list.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/instructions_list.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/recipe_info_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/tools_list.dart';
import 'package:yumm_ai/features/cooking/presentation/providers/recipe_state_provider.dart';

class RecipeDetailsWidget extends ConsumerStatefulWidget {
  final RecipeEntity recipe;
  const RecipeDetailsWidget({super.key, required this.recipe});

  @override
  ConsumerState<RecipeDetailsWidget> createState() =>
      _RecipeDetailsWidgetState();
}

class _RecipeDetailsWidgetState extends ConsumerState<RecipeDetailsWidget>
    with SingleTickerProviderStateMixin {
  static const double _collapsedFraction = 0.64;
  static const double _expandedFraction = 0.9;

  late final DraggableScrollableController _draggableController;
  late TabController _tabController;
  int _currentTabIndex = 0;

  bool get _isSheetAttached => _draggableController.isAttached;

  void _toggleIngredient(int index, bool value) {
    ref
        .read(recipeStateCacheProvider.notifier)
        .toggleIngredient(widget.recipe.recipeId, index, value);
  }

  void _toggleInstruction(int index, bool value) {
    ref
        .read(recipeStateCacheProvider.notifier)
        .toggleInstruction(widget.recipe.recipeId, index, value);
  }

  void _toggleTool(int index, bool value) {
    ref
        .read(recipeStateCacheProvider.notifier)
        .toggleKitchenTool(widget.recipe.recipeId, index, value);
  }

  void _handleDragUpdate(DragUpdateDetails details, double parentHeight) {
    final delta = details.primaryDelta;
    if (delta == null || parentHeight == 0 || !_isSheetAttached) return;

    final newSize = (_draggableController.size - delta / parentHeight).clamp(
      _collapsedFraction,
      _expandedFraction,
    );
    _draggableController.jumpTo(newSize);
  }

  void _snapSheet() {
    if (!_isSheetAttached) return;
    final midpoint = (_collapsedFraction + _expandedFraction) / 2;
    final target = _draggableController.size >= midpoint
        ? _expandedFraction
        : _collapsedFraction;

    _draggableController.animateTo(
      target,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
    );
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    if (_currentTabIndex != _tabController.index) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Initialize the recipe state provider with the passed recipe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(recipeStateCacheProvider.notifier)
          .initializeIfNeeded(widget.recipe.recipeId, widget.recipe);
    });
  }

  @override
  void dispose() {
    _draggableController.dispose();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Watch the recipe state from the provider
    final recipeSnapshot = ref.watch(
      recipeStateProvider(widget.recipe.recipeId),
    );
    final currentRecipe = recipeSnapshot.recipe ?? widget.recipe;

    return Align(
      alignment: Alignment.bottomCenter,
      child: DraggableScrollableSheet(
        controller: _draggableController,
        initialChildSize: _collapsedFraction,
        minChildSize: _collapsedFraction,
        maxChildSize: _expandedFraction,
        snap: true,
        builder: (context, scrollController) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final parentHeight = constraints.biggest.height;

              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragUpdate: (details) =>
                    _handleDragUpdate(details, parentHeight),
                onVerticalDragEnd: (_) => _snapSheet(),
                child: Container(
                  clipBehavior: Clip.none,
                  width: screenWidth,
                  padding: const EdgeInsets.only(top: 14),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    boxShadow: [ContainerProperty.darkerShadow],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: screenWidth * 0.3,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.descriptionTextColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          widget.recipe.recipeName,
                          style: AppTextStyles.h2.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ReadMoreWidget(
                          text: widget.recipe.description,
                          trimLine: 3,
                        ),
                      ),

                      // Recipe Info
                      RecipeInfoCard(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        duration: currentRecipe.estCookingTime,
                        steps: currentRecipe.steps.length,
                        expertise: currentRecipe.experienceLevel,
                      ),

                      // Tab Bar
                      CustomTabBar(
                        externalController: _tabController,
                        tabItems: const [
                          "Ingredients",
                          "Instructions",
                          "Tools",
                        ],
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        itemTextStyle: AppTextStyles.descriptionText.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                        ),
                        // onTabChanged: (value) {},
                      ),

                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            IngredientList(
                              isActive: _currentTabIndex == 0,
                              scrollController: scrollController,
                              ingredients: currentRecipe.ingredients,
                              onToggle: _toggleIngredient,
                            ),
                            InstructionsList(
                              scrollController: scrollController,
                              isActive: _currentTabIndex == 1,
                              instruction: currentRecipe.steps,
                              onToggle: _toggleInstruction,
                            ),
                            ToolsList(
                              kitchenTool: currentRecipe.kitchenTools,
                              isActive: _currentTabIndex == 2,
                              scrollController: scrollController,
                              onToggle: _toggleTool,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
