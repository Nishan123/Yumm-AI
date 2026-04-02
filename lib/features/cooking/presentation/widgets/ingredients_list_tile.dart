import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/cached_image_error_widget.dart';

class IngredientsListTile extends StatefulWidget {
  final IngredientModel ingredient;
  final Color textColor;
  final Function(bool?)? onChecked;

  const IngredientsListTile({
    super.key,
    required this.ingredient,
    required this.textColor,
    required this.onChecked,
  });

  @override
  State<IngredientsListTile> createState() => _IngredientsListTileState();
}

class _IngredientsListTileState extends State<IngredientsListTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _popController;
  late final Animation<double> _popScale;

  late bool _wasChecked;

  @override
  void initState() {
    super.initState();
    _wasChecked = widget.ingredient.isReady;

    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _popScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.94, // Premium Apple feel: Press inwards
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.94,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)), // Snappy spring release
        weight: 60,
      ),
    ]).animate(_popController);
  }

  @override
  void didUpdateWidget(IngredientsListTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.ingredient.isReady == _wasChecked) return;
    _wasChecked = widget.ingredient.isReady;

    if (widget.ingredient.isReady) {
      // Trigger pop animation when checked
      _popController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _popController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _popController,
      builder: (context, child) {
        return Transform.scale(
          scale: _popScale.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          if (widget.onChecked != null) {
            widget.onChecked!(!widget.ingredient.isReady);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: widget.ingredient.isReady
                ? AppColors.primaryColor.withAlpha(20)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              width: 0.6,
              color: widget.ingredient.isReady
                  ? AppColors.primaryColor.withAlpha(128)
                  : AppColors.borderColor,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: widget.ingredient.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: widget.ingredient.imageUrl,
                        errorWidget: (context, url, error) {
                          return CachedImageErrorWidget(
                            backgroundColor: widget.textColor,
                            icon: LucideIcons.salad,
                          );
                        },
                      )
                    : CachedImageErrorWidget(
                        backgroundColor: widget.textColor,
                        icon: LucideIcons.salad,
                      ),
              ),
              const SizedBox(width: 8),
              Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ingredient.name,
                    style: AppTextStyles.normalText.copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.ingredient.isReady
                          ? widget.textColor.withAlpha(128)
                          : widget.textColor,
                      decoration: widget.ingredient.isReady
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.descriptionText.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: widget.ingredient.isReady
                            ? AppColors.descriptionTextColor.withAlpha(128)
                            : AppColors.descriptionTextColor,
                        decoration: widget.ingredient.isReady
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      children: [
                        TextSpan(
                          text:
                              "${widget.ingredient.quantity} ${widget.ingredient.unit.toUpperCase()}",
                          style: AppTextStyles.descriptionText.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: widget.ingredient.isReady
                                ? AppColors.descriptionTextColor.withAlpha(128)
                                : AppColors.descriptionTextColor,
                            decoration: widget.ingredient.isReady
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Checkbox(
                value: widget.ingredient.isReady,
                onChanged: widget.onChecked,
                activeColor: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
