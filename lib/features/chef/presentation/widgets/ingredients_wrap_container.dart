import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_chip.dart';


class IngredientsWrapContainer extends StatelessWidget {
  final List<Widget> items;
  final EdgeInsets? margin;
  final String? emptyText;
  final bool? haveAddIngredientButton;
  final VoidCallback? onAddIngredientButtonPressed;

  const IngredientsWrapContainer({
    super.key,
    required this.items,
    this.margin,
    this.emptyText,
    this.haveAddIngredientButton,
    this.onAddIngredientButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOutCubic,
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      child: Container(
        margin: margin ?? ConstantsString.commonPadding,
        padding: const EdgeInsets.only(left: 1, top: 10, bottom: 8, right: 0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.extraLightBlackColor,
          borderRadius: BorderRadius.circular(28),
          border: ContainerProperty.mainBorder,
          boxShadow: [ContainerProperty.mainShadow],
        ),
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 280),
          crossFadeState: items.isEmpty
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstCurve: Curves.easeOut,
          secondCurve: Curves.easeOut,
          sizeCurve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          firstChild: SizedBox(
            height: 120,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    emptyText ?? "No Ingredients Selected",
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.descriptionTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (haveAddIngredientButton ?? false)
                    const SizedBox(height: 12),
                  if (haveAddIngredientButton ?? false)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.blackColor,
                        foregroundColor: AppColors.whiteColor,
                      ),
                      onPressed: onAddIngredientButtonPressed,
                      child: const Text("Add Item"),
                    ),
                ],
              ),
            ),
          ),
          secondChild: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: _AnimatedWrapItems(items: items),
          ),
        ),
      ),
    );
  }
}

// ── Animated Wrapper for Wrap Items ──────────────────────────────────────────

class _AnimatedWrapItems extends StatefulWidget {
  final List<Widget> items;
  const _AnimatedWrapItems({required this.items});

  @override
  State<_AnimatedWrapItems> createState() => _AnimatedWrapItemsState();
}

class _AnimatedWrapItemsState extends State<_AnimatedWrapItems> {
  final List<_WrapItemModel> _models = [];

  Key _getKey(Widget widget, int index) {
    if (widget.key != null) return widget.key!;
    if (widget is IngredientsChip) return ValueKey(widget.text);
    return ValueKey(index);
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.items.length; i++) {
      _models.add(_WrapItemModel(
        key: _getKey(widget.items[i], i),
        widget: widget.items[i],
        initialIndex: i,
      ));
    }
  }

  @override
  void didUpdateWidget(covariant _AnimatedWrapItems oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newKeys = <Key>{};
    for (int i = 0; i < widget.items.length; i++) {
      newKeys.add(_getKey(widget.items[i], i));
    }

    // Mark missing items as removing
    for (var model in _models) {
      if (!newKeys.contains(model.key) && !model.isRemoving) {
        model.isRemoving = true;
      }
    }

    // Add or update items
    final currentKeys = _models.map((m) => m.key).toSet();
    for (int i = 0; i < widget.items.length; i++) {
      final key = _getKey(widget.items[i], i);
      if (!currentKeys.contains(key)) {
        _models.add(_WrapItemModel(
            key: key, widget: widget.items[i], initialIndex: _models.length));
      } else {
        final model = _models.firstWhere((m) => m.key == key);
        model.widget = widget.items[i];
      }
    }

    // We intentionally do not sort `_models` here so that any removed items
    // stay exactly in their current structural position while they animate out,
    // and any new items are simply appended to the end.
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _models.map((model) {
        return _RemovingAnimatedWrapItem(
          key: model.key,
          isRemoving: model.isRemoving,
          initialIndex: model.initialIndex,
          onRemoved: () {
            if (mounted) {
              setState(() {
                _models.removeWhere((m) => m.key == model.key);
              });
            }
          },
          child: model.widget,
        );
      }).toList(),
    );
  }
}

class _WrapItemModel {
  final Key key;
  Widget widget;
  bool isRemoving = false;
  final int initialIndex;
  _WrapItemModel({
    required this.key,
    required this.widget,
    required this.initialIndex,
  });
}

class _RemovingAnimatedWrapItem extends StatefulWidget {
  final Widget child;
  final bool isRemoving;
  final VoidCallback onRemoved;
  final int initialIndex;

  const _RemovingAnimatedWrapItem({
    super.key,
    required this.child,
    required this.isRemoving,
    required this.onRemoved,
    required this.initialIndex,
  });

  @override
  State<_RemovingAnimatedWrapItem> createState() =>
      _RemovingAnimatedWrapItemState();
}

class _RemovingAnimatedWrapItemState extends State<_RemovingAnimatedWrapItem>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  bool _hasStartedExit = false;

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
    Future.delayed(Duration(milliseconds: widget.initialIndex * 55), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant _RemovingAnimatedWrapItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRemoving && !oldWidget.isRemoving && !_hasStartedExit) {
      _hasStartedExit = true;
      _controller.duration = const Duration(milliseconds: 250); // Faster exit
      
      // Flutter automatically reverses the existing curves correctly
      _controller.reverse().then((_) {
        widget.onRemoved();
      });
    }
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
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

