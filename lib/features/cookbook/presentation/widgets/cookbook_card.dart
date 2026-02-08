import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/widgets/custom_dialogue_box.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';

class CookbookCard extends StatefulWidget {
  final Key dismissibleKey;
  final CookbookRecipeEntity recipe;
  final Future<bool> Function()? onDelete;
  final bool isOwner;

  const CookbookCard({
    super.key,
    required this.dismissibleKey,
    required this.recipe,
    this.onDelete,
    this.isOwner = false,
  });

  @override
  State<CookbookCard> createState() => _CookbookCardState();
}

class _CookbookCardState extends State<CookbookCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Dismissible(
      confirmDismiss: (direction) async {
        HapticFeedback.mediumImpact();
        final confirmed = await CustomDialogueBox.show(
          context,
          title: widget.isOwner ? "Delete Recipe" : "Remove from Cookbook",
          description: widget.isOwner
              ? "Are you sure you want to delete this recipe? This will also remove it from all users' cookbooks."
              : "Are you sure you want to remove this recipe from your cookbook?",
          onActionButtonTap: () {}, // Handled by manual result return
          actionButtonText: "Delete",
          okText: "Cancel",
        );

        if (confirmed == true && widget.onDelete != null) {
          return await widget.onDelete!();
        }
        return false;
      },
      onDismissed: (_) {
        HapticFeedback.heavyImpact();
      },
      background: Container(
        margin: const EdgeInsets.only(left: 18, right: 18, bottom: 24),
        padding: const EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
          color: AppColors.redColor,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Icon(Icons.delete_outline, color: Colors.white, size: 32),
            const SizedBox(height: 4),
            Text(
              'Delete',
              style: AppTextStyles.normalText.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      key: widget.dismissibleKey,
      direction: DismissDirection.endToStart,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(left: 18, right: 18, bottom: 24),
          width: mq.width,
          decoration: BoxDecoration(
            color: AppColors.extraLightBlackColor,
            border: ContainerProperty.mainBorder,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              ContainerProperty.mainShadow,
              BoxShadow(
                color: _isComplete()
                    ? AppColors.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Container
                  SizedBox(
                    width: mq.width * 0.27,
                    height: mq.width * 0.27,
                    child: Hero(
                      tag: 'recipe_image_${widget.recipe.userRecipeId}',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 2.5,
                            color: AppColors.whiteColor,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Placeholder
                              Container(
                                color: AppColors.descriptionTextColor
                                    .withOpacity(0.1),
                                child: Icon(
                                  Icons.restaurant_menu,
                                  color: AppColors.descriptionTextColor
                                      .withOpacity(0.3),
                                  size: 40,
                                ),
                              ),
                              // Actual Image
                              widget.recipe.images.isNotEmpty
                                  ? Image.network(
                                      widget.recipe.images.first,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                value:
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                      errorBuilder: (_, __, ___) => Image.asset(
                                        "${ConstantsString.assetImage}/salad.png",
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
                                      "${ConstantsString.assetImage}/salad.png",
                                      fit: BoxFit.cover,
                                    ),
                              // Completion Badge
                              if (_isComplete())
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.5),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Information Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.recipe.recipeName,
                          style: AppTextStyles.title.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.recipe.description,
                          style: AppTextStyles.normalText.copyWith(
                            color: AppColors.descriptionTextColor,
                            fontSize: 11,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        // Info chips
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            _buildInfoChip(
                              Icons.local_fire_department_outlined,
                              widget.recipe.experienceLevel,
                            ),
                            _buildInfoChip(
                              Icons.access_time_outlined,
                              widget.recipe.estCookingTime,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Progress bar
                        _buildProgressBar(),
                        const SizedBox(height: 3),
                        Text(
                          _getProgressText(),
                          style: AppTextStyles.normalText.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: _isComplete()
                                ? AppColors.primaryColor
                                : AppColors.descriptionTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTapDown: (_) {
                  _controller.forward();
                  HapticFeedback.lightImpact();
                },
                onTapUp: (_) {
                  _controller.reverse();
                },
                onTapCancel: () {
                  _controller.reverse();
                },
                child: SecondaryButton(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  haveHatIcon: true,
                  borderRadius: 40,
                  backgroundColor: _isComplete()
                      ? AppColors.primaryColor
                      : AppColors.blackColor,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    context.push(
                      '/cooking',
                      extra: widget.recipe.toRecipeEntity(),
                    );
                  },
                  text: _isComplete() ? "Cook Again" : "Continue Cooking",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.blackColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.descriptionTextColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.descriptionTextColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.normalText.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = _getOverallProgress();
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 6,
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.descriptionTextColor.withOpacity(0.15),
          valueColor: AlwaysStoppedAnimation<Color>(
            _isComplete() ? AppColors.primaryColor : AppColors.redColor,
          ),
        ),
      ),
    );
  }

  double _getOverallProgress() {
    final totalIngredients = widget.recipe.ingredients.length;
    final doneIngredients = widget.recipe.ingredients
        .where((i) => i.isReady)
        .length;
    final totalSteps = widget.recipe.steps.length;
    final doneSteps = widget.recipe.steps.where((s) => s.isDone).length;

    final totalTasks = totalIngredients + totalSteps;
    final doneTasks = doneIngredients + doneSteps;

    return totalTasks > 0 ? doneTasks / totalTasks : 0;
  }

  String _getProgressText() {
    final totalIngredients = widget.recipe.ingredients.length;
    final doneIngredients = widget.recipe.ingredients
        .where((i) => i.isReady)
        .length;
    final totalSteps = widget.recipe.steps.length;
    final doneSteps = widget.recipe.steps.where((s) => s.isDone).length;

    if (_isComplete()) {
      return "🎉 Recipe Complete!";
    }

    final overallProgress = (_getOverallProgress() * 100).toInt();
    return "$overallProgress% • $doneIngredients/$totalIngredients ingredients • $doneSteps/$totalSteps steps";
  }

  bool _isComplete() {
    final allIngredientsDone = widget.recipe.ingredients.every(
      (i) => i.isReady,
    );
    final allStepsDone = widget.recipe.steps.every((s) => s.isDone);
    return allIngredientsDone && allStepsDone;
  }
}
