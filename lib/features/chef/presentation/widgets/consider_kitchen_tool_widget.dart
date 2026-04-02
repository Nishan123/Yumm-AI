import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/widgets/input_widget_title.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_kitchen_tool_entity.dart';

class ConsiderKitchenToolWidget extends StatelessWidget {
  final Function(bool) onSelect;
  final bool isSelected;
  final List<RecipeKitchenToolEntity> kitchenTools;

  const ConsiderKitchenToolWidget({
    super.key,
    required this.isSelected,
    required this.onSelect,
    required this.kitchenTools,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final hasTools = kitchenTools.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InputWidgetTitle(
                title: "Select available tools",
                padding: EdgeInsets.zero,
              ),
              const Spacer(),
              Switch(value: isSelected, onChanged: onSelect),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topCenter,
            child: Container(
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: ContainerProperty.mainBorder,
                color: AppColors.extraLightBlackColor,
                boxShadow: [ContainerProperty.mainShadow],
              ),
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 280),
                crossFadeState: hasTools
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstCurve: Curves.easeOut,
                secondCurve: Curves.easeOut,
                sizeCurve: Curves.easeInOutCubic,
                layoutBuilder: (topChild, topKey, bottomChild, bottomKey) {
                  return Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(key: bottomKey, top: 0, child: bottomChild),
                      Positioned(key: topKey, child: topChild),
                    ],
                  );
                },
                firstChild: const _EmptyToolsPlaceholder(),
                secondChild: _ToolsWrap(kitchenTools: kitchenTools),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyToolsPlaceholder extends StatelessWidget {
  const _EmptyToolsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 8,
        children: [
          Text("Kitchen tools not selected", style: AppTextStyles.h5),
          Text(
            "We will list basic tools to prepare this meal",
            style: AppTextStyles.descriptionText,
          ),
        ],
      ),
    );
  }
}

// ── Tools wrap with staggered entrance ───────────────────────────────────────

class _ToolsWrap extends StatelessWidget {
  final List<RecipeKitchenToolEntity> kitchenTools;

  const _ToolsWrap({required this.kitchenTools});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (int i = 0; i < kitchenTools.length; i++)
          _KitchenToolChip(
            key: ValueKey(kitchenTools[i].toolName),
            toolName: kitchenTools[i].toolName,
            index: i,
          ),
      ],
    );
  }
}

// ── Individual chip with smooth staggered pop-in ─────────────────────────────

class _KitchenToolChip extends StatefulWidget {
  final String toolName;
  final int index;

  const _KitchenToolChip({
    super.key,
    required this.toolName,
    required this.index,
  });

  @override
  State<_KitchenToolChip> createState() => _KitchenToolChipState();
}

class _KitchenToolChipState extends State<_KitchenToolChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack, // Subtle, polished spring — no jitter
    );

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
    );

    // Staggered delay per chip
    Future.delayed(Duration(milliseconds: widget.index * 55), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: AppColors.primaryColor,
          ),
          child: Text(
            widget.toolName,
            style: AppTextStyles.normalText.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
