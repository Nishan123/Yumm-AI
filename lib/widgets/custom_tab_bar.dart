import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/core/styles/custom_shadow.dart';

class CustomTabBar extends StatefulWidget {
  final Function(int)? onTabChanged;
  final List<String> tabItems;
  final TabController? externalController;
  const CustomTabBar({
    super.key,
    this.onTabChanged,
    this.externalController,
    required this.tabItems,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        widget.externalController ??
        TabController(length: widget.tabItems.length, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (widget.onTabChanged != null) {
      widget.onTabChanged!(_tabController.index);
    }
  }

  @override
  void dispose() {
    if (widget.externalController == null) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlackColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(width: 4, color: AppColors.whiteColor),
        boxShadow: [
          CustomShadow.mainShadow
        ]
      ),
      child: TabBar(
        controller: _tabController,
        tabs: widget.tabItems.map((tab) => Tab(text: tab)).toList(),
        indicator: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: AppTextStyles.normalText.copyWith(fontWeight: FontWeight.w700),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(6),
        labelColor: Colors.black,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}
