import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/core/styles/container_property.dart';
import 'package:yumm_ai/screens/cooking/widgets/ingredient_list.dart';
import 'package:yumm_ai/screens/cooking/widgets/instructions_list.dart';
import 'package:yumm_ai/screens/cooking/widgets/recipe_info_card.dart';
import 'package:yumm_ai/screens/cooking/widgets/tools_list.dart';
import 'package:yumm_ai/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/widgets/read_more_widget.dart';

class RecipeDetailsWidget extends StatefulWidget {
  const RecipeDetailsWidget({super.key});

  @override
  State<RecipeDetailsWidget> createState() => _RecipeDetailsWidgetState();
}

class _RecipeDetailsWidgetState extends State<RecipeDetailsWidget>
    with SingleTickerProviderStateMixin {
  static const double _collapsedFraction = 0.62;
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
                  padding: const EdgeInsets.only(top: 14, left: 16, right: 16),
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
                          color: AppColors.blackColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "AI Generated Recipe Title or Name",
                        style: AppTextStyles.h2.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const ReadMoreWidget(
                        text:
                            "Savor the zest of hot chicken legs enhanced with a citrus shower of lemon, combining spicy warmth with a refreshing tang. Short description of the Food with some rich  laskdl lkas dlaks d history of origin of the food kdsnjfk sdkfj sa flkasd kla slkdc sald c.jkas dkcs kldj ",
                        trimLine: 3,
                      ),
                      const RecipeInfoCard(),
                      CustomTabBar(
                        externalController: _tabController,
                        tabItems: const [
                          "Ingredients",
                          "Instructions",
                          "Tools",
                        ],
                        margin: const EdgeInsets.symmetric(horizontal: 0),
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
                            IngredientList(
                              scrollController: scrollController,
                              isActive: _currentTabIndex == 0,
                            ),
                            InstructionsList(
                              scrollController: scrollController,
                              isActive: _currentTabIndex == 1,
                            ),
                            ToolsList(
                              scrollController: scrollController,
                              isActive: _currentTabIndex == 2,
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
