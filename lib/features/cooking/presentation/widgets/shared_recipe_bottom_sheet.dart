import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/core/widgets/read_more_widget.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/nutritions_info_card.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/recipe_info_card.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/recipe_title_widget.dart';

class SharedRecipeBottomSheet extends StatefulWidget {
  final RecipeEntity recipe;
  final Widget ingredientsBody;
  final Widget instructionsBody;
  final Widget toolsBody;
  final Widget? actionWidget;
  final int initialTabIndex;
  final ValueChanged<int>? onTabChanged;

  const SharedRecipeBottomSheet({
    super.key,
    required this.recipe,
    required this.ingredientsBody,
    required this.instructionsBody,
    required this.toolsBody,
    this.actionWidget,
    this.initialTabIndex = 0,
    this.onTabChanged,
  });

  @override
  State<SharedRecipeBottomSheet> createState() =>
      _SharedRecipeBottomSheetState();
}

class _SharedRecipeBottomSheetState extends State<SharedRecipeBottomSheet>
    with SingleTickerProviderStateMixin {
  static const double _collapsedFraction = 0.64;
  static const double _expandedFraction = 0.9;
  bool _isTitleExpanded = false;

  late final DraggableScrollableController _draggableController;
  late TabController _tabController;
  int _currentTabIndex = 0;

  bool get _isSheetAttached => _draggableController.isAttached;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialTabIndex;
    _draggableController = DraggableScrollableController();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _currentTabIndex,
    );
    _tabController.addListener(_handleTabChange);
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
      if (widget.onTabChanged != null) {
        widget.onTabChanged!(_currentTabIndex);
      }
    }
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
                                duration: widget.recipe.estCookingTime,
                                steps: widget.recipe.steps.length,
                                expertise: widget.recipe.experienceLevel,
                              ),
                              const SizedBox(height: 6),

                              // Optional Action Widget (e.g., Add to Cookbook Button)
                              if (widget.actionWidget != null) ...[
                                widget.actionWidget!,
                                const SizedBox(height: 16),
                              ],

                              // Nutrition info
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
                        widget.ingredientsBody,
                        widget.instructionsBody,
                        widget.toolsBody,
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

/// Delegate for the sticky tab bar that pins at the top when scrolling.
class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  StickyTabBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 66.0;

  @override
  double get minExtent => 66.0;

  @override
  bool shouldRebuild(StickyTabBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
