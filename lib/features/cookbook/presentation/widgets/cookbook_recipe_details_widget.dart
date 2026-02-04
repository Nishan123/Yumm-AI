import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/core/widgets/read_more_widget.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';
import 'package:yumm_ai/features/cookbook/presentation/view_model/cookbook_view_model.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/ingredient_list.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/instructions_list.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/nutritions_info_card.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/recipe_details_widget.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/recipe_info_card.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/recipe_title_widget.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/tools_list.dart';

/// Interactive recipe details widget for recipes that are in the user's cookbook.
/// Allows users to check/uncheck ingredients, instructions, and tools.
class CookbookRecipeDetailsWidget extends ConsumerStatefulWidget {
  final CookbookRecipeEntity recipe;

  const CookbookRecipeDetailsWidget({super.key, required this.recipe});

  @override
  ConsumerState<CookbookRecipeDetailsWidget> createState() =>
      _CookbookRecipeDetailsWidgetState();
}

class _CookbookRecipeDetailsWidgetState
    extends ConsumerState<CookbookRecipeDetailsWidget>
    with SingleTickerProviderStateMixin {
  static const double _collapsedFraction = 0.64;
  static const double _expandedFraction = 0.9;
  bool _isTitleExpanded = false;

  late final DraggableScrollableController _draggableController;
  late TabController _tabController;
  int _currentTabIndex = 0;

  bool get _isSheetAttached => _draggableController.isAttached;

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

  void _toggleIngredient(int index, bool value) {
    ref.read(cookbookViewModelProvider.notifier).toggleIngredient(index, value);
  }

  void _toggleInstruction(int index, bool value) {
    ref
        .read(cookbookViewModelProvider.notifier)
        .toggleInstruction(index, value);
  }

  void _toggleTool(int index, bool value) {
    ref
        .read(cookbookViewModelProvider.notifier)
        .toggleKitchenTool(index, value);
  }

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
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
    final cookbookState = ref.watch(cookbookViewModelProvider);
    final currentRecipe = cookbookState.currentRecipe ?? widget.recipe;

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
                  clipBehavior: Clip.antiAlias,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    boxShadow: [ContainerProperty.darkerShadow],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: NestedScrollView(
                    controller: scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        // Header content that scrolls away
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 14),
                              // Drag handle
                              Container(
                                width: screenWidth * 0.3,
                                height: 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.descriptionTextColor,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Recipe Title
                              RecipeTitleWidget(
                                recipeName: widget.recipe.recipeName,
                                onTap: () {
                                  setState(() {
                                    _isTitleExpanded = !_isTitleExpanded;
                                  });
                                },
                                isTitleExpanded: _isTitleExpanded,
                              ),
                              const SizedBox(height: 6),

                              // Recipe Description
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: ReadMoreWidget(
                                  text: widget.recipe.description,
                                  trimLine: 3,
                                ),
                              ),

                              // Recipe Info
                              RecipeInfoCard(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                duration: currentRecipe.estCookingTime,
                                steps: currentRecipe.steps.length,
                                expertise: currentRecipe.experienceLevel,
                              ),
                              const SizedBox(height: 6),

                              // nutritions info
                              if (widget.recipe.nutrition != null)
                                NutritionsInfoCard(
                                  fat: widget.recipe.nutrition!.fat,
                                  carbs: widget.recipe.nutrition!.carbs,
                                  calories: widget.recipe.calorie.toDouble(),
                                  fiber: widget.recipe.nutrition!.fiber,
                                ),
                              const SizedBox(height: 3),
                            ],
                          ),
                        ),

                        // Pinned Tab Bar
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: StickyTabBarDelegate(
                            child: Container(
                              color: AppColors.whiteColor,
                              padding: const EdgeInsets.only(
                                top: 14,
                                bottom: 3,
                              ),
                              child: CustomTabBar(
                                externalController: _tabController,
                                tabItems: const [
                                  "Ingredients",
                                  "Instructions",
                                  "Tools",
                                ],
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                itemTextStyle: AppTextStyles.descriptionText
                                    .copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.blackColor,
                                    ),
                                onTabChanged: (value) {},
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        IngredientList(
                          isActive: _currentTabIndex == 0,
                          ingredients: currentRecipe.ingredients,
                          onToggle: _toggleIngredient,
                        ),
                        InstructionsList(
                          isActive: _currentTabIndex == 1,
                          instruction: currentRecipe.steps,
                          onToggle: _toggleInstruction,
                        ),
                        ToolsList(
                          kitchenTool: currentRecipe.kitchenTools,
                          isActive: _currentTabIndex == 2,
                          onToggle: _toggleTool,
                        ),
                      ],
                    ),
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
