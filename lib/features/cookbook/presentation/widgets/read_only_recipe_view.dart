import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/core/widgets/primary_button.dart';
import 'package:yumm_ai/core/widgets/read_more_widget.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/recipe_info_card.dart';

/// A read-only view of recipe details for users who haven't added the recipe
/// to their cookbook. Shows recipe information without interactive checkboxes.
class ReadOnlyRecipeView extends StatefulWidget {
  final RecipeEntity recipe;
  final VoidCallback onAddToCookbook;
  final bool isAddingToCookbook;

  const ReadOnlyRecipeView({
    super.key,
    required this.recipe,
    required this.onAddToCookbook,
    this.isAddingToCookbook = false,
  });

  @override
  State<ReadOnlyRecipeView> createState() => _ReadOnlyRecipeViewState();
}

class _ReadOnlyRecipeViewState extends State<ReadOnlyRecipeView>
    with SingleTickerProviderStateMixin {
  static const double _collapsedFraction = 0.64;
  static const double _expandedFraction = 0.9;

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
                      RecipeInfoCard(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        duration: widget.recipe.estCookingTime,
                        steps: widget.recipe.steps.length,
                        expertise: widget.recipe.experienceLevel,
                      ),
                      // Add to Cookbook Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: PrimaryButton(
                          text: widget.isAddingToCookbook
                              ? "Adding..."
                              : "Add to Cookbook to Start Cooking",
                          isLoading: widget.isAddingToCookbook,
                          onTap: widget.onAddToCookbook,
                        ),
                      ),
                      const SizedBox(height: 14),
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
                        onTabChanged: (value) {},
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildReadOnlyIngredientsList(scrollController),
                            _buildReadOnlyInstructionsList(scrollController),
                            _buildReadOnlyToolsList(scrollController),
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

  Widget _buildReadOnlyIngredientsList(ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: widget.recipe.ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = widget.recipe.ingredients[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.extraLightBlackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (ingredient.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    ingredient.imageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 48,
                      height: 48,
                      color: AppColors.descriptionTextColor.withOpacity(0.3),
                      child: const Icon(Icons.restaurant, size: 24),
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ingredient.name,
                      style: AppTextStyles.normalText.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${ingredient.quantity} ${ingredient.unit}",
                      style: AppTextStyles.descriptionText.copyWith(
                        color: AppColors.descriptionTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.check_circle_outline,
                color: AppColors.descriptionTextColor.withOpacity(0.5),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReadOnlyInstructionsList(ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: widget.recipe.steps.length,
      itemBuilder: (context, index) {
        final step = widget.recipe.steps[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.extraLightBlackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.descriptionTextColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "${index + 1}",
                    style: AppTextStyles.normalText.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(step.instruction, style: AppTextStyles.normalText),
              ),
              Icon(
                Icons.check_circle_outline,
                color: AppColors.descriptionTextColor.withOpacity(0.5),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReadOnlyToolsList(ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: widget.recipe.kitchenTools.length,
      itemBuilder: (context, index) {
        final tool = widget.recipe.kitchenTools[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.extraLightBlackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (tool.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    tool.imageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 48,
                      height: 48,
                      color: AppColors.descriptionTextColor.withOpacity(0.3),
                      child: const Icon(Icons.kitchen, size: 24),
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tool.toolName,
                  style: AppTextStyles.normalText.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.check_circle_outline,
                color: AppColors.descriptionTextColor.withOpacity(0.5),
              ),
            ],
          ),
        );
      },
    );
  }
}
