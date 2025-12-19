import 'package:flutter/material.dart';
import 'package:yumm_ai/core/consts/constants.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/core/styles/container_property.dart';

class CustomTabBar<T> extends StatefulWidget {
  final Function(T)? onTabChanged;
  final List<String> tabItems;
  final List<T>? values;
  final TabController? externalController;
  final EdgeInsets? margin;
  final String? initialValue;
  final TextStyle? itemTextStyle;

  const CustomTabBar({
    super.key,
    this.onTabChanged,
    this.externalController,
    required this.tabItems,
    this.values,
    this.margin,
    this.initialValue,
    this.itemTextStyle
  }) : assert(
         values == null || values.length == tabItems.length,
         "Values list length must match tabItems length",
       ),
       assert(
         initialValue == null || values != null,
         "initialValue requires values to map against",
       );

  @override
  State<CustomTabBar<T>> createState() => _CustomTabBarState<T>();
}

class _CustomTabBarState<T> extends State<CustomTabBar<T>>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialIndex = _resolveInitialIndex();
    _tabController =
        widget.externalController ??
        TabController(
          length: widget.tabItems.length,
          vsync: this,
          initialIndex: initialIndex,
        );
    _tabController.addListener(_handleTabChange);
  }

  int _resolveInitialIndex() {
    if (widget.initialValue == null || widget.values == null) return 0;
    final index = widget.values!.indexWhere(
      (value) => value == widget.initialValue,
    );
    return (index >= 0 && index < widget.tabItems.length) ? index : 0;
  }

  void _handleTabChange() {
    if (widget.onTabChanged != null && !_tabController.indexIsChanging) {
      // If values are provided, return the value at the index, otherwise return index as T (if T is int)
      if (widget.values != null) {
        widget.onTabChanged!(widget.values![_tabController.index]);
      } else if (T == int) {
        widget.onTabChanged!(_tabController.index as T);
      }
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
      margin: widget.margin ?? Constants.commonPadding,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.extraLightBlackColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(width: 4, color: AppColors.whiteColor),
        boxShadow: [ContainerProperty.mainShadow],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: widget.tabItems.map((tab) => Tab(text: tab)).toList(),
        indicator: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: widget.itemTextStyle?? AppTextStyles.normalText.copyWith(
          fontWeight: FontWeight.w700,
        ),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(6),
        labelColor: Colors.black,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}
