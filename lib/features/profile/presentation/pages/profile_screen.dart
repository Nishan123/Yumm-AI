import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/providers/user_selectors.dart';
import 'package:yumm_ai/core/widgets/custom_dialogue_box.dart';
import 'package:yumm_ai/core/widgets/input_widget_title.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/core/widgets/secondary_icon_button.dart';
import 'package:yumm_ai/features/chef/data/models/Ingrident_model.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/add_ingredients_bottom_sheet.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_wrap_container.dart';
import 'package:yumm_ai/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:yumm_ai/features/profile/presentation/widgets/profile_card.dart';
import 'package:yumm_ai/features/profile/presentation/widgets/profile_pic_source_bottom_sheet.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final userNameController = TextEditingController();
  List<IngredientModel> selectedIngredients = [];
  bool _isInitialized = false;
  final ImagePicker _imagePicker = ImagePicker();

  void _showPermissionDeniedDailog() {
    CustomDialogueBox.show(
      context,
      title: "Permission Required !",
      description:
          "This feature requires access from your midea or camera. Please enable it in your device settings",
      okText: "Cancel",
      actionButtonText: "Open Setting",
      onActionButtonTap: () {
        openAppSettings();
      },
    );
  }

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;
    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }
    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDailog();
      return false;
    }
    return false;
  }

  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestPermission(Permission.camera);
    if (!hasPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (photo != null) {
      ref
          .read(profileViewModelProvider.notifier)
          .updateProfilePic(File(photo.path));
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        ref
            .read(profileViewModelProvider.notifier)
            .updateProfilePic(File(image.path));
      }
    } catch (e) {
      debugPrint("Failed to update profile pic");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final userName = ref.read(userNameProvider);
      if (userName != null && userName.isNotEmpty) {
        userNameController.text = userName;
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in
    final isLoggedIn = ref.watch(isUserLoggedInProvider);

    if (!isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: Center(
          child: Text(
            'Please log in to view your profile',
            style: TextStyle(color: AppColors.descriptionTextColor),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constrains) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(currentUserProvider);
                ref.invalidate(userProfilePicProvider);
                await Future<void>.delayed(const Duration(milliseconds: 300));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constrains.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          // ProfileCard now fetches its own data using userProfileCardDataProvider
                          ProfileCard(
                            userNameController: userNameController,
                            onProfileIconTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ProfilePicSourceBottomSheet(
                                    onGalleryTap: _pickFromGallery,
                                    onCameraTap: _pickFromCamera,
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          InputWidgetTitle(
                            title: "You are allergic to :",
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            onActionTap: () {},
                          ),
                          const SizedBox(height: 12),
                          // allergic items container
                          IngredientsWrapContainer(
                            haveAddIngredientButton: true,
                            onAddIngredientButtonPressed: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return AddIngredientsBottomSheet(
                                    title: "Search ingredients",
                                    selectedIngredients: selectedIngredients,
                                    onSubmit:
                                        (List<IngredientModel> newSelection) {
                                          setState(() {
                                            selectedIngredients = newSelection;
                                          });
                                        },
                                  );
                                },
                              );
                            },
                            emptyText: "No Allergic Ingredients",
                            margin: const EdgeInsets.all(0),
                            items: selectedIngredients
                                .map(
                                  (ing) => AllergicItemChips(
                                    onTap: () {
                                      setState(() {
                                        selectedIngredients.removeWhere(
                                          (item) => item.id == ing.id,
                                        );
                                      });
                                    },
                                    text: ing.id,
                                  ),
                                )
                                .toList(),
                          ),
                          Spacer(),
                          SecondaryButton(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 4,
                            ),
                            borderRadius: 40,
                            backgroundColor: AppColors.lightBlueColor,
                            onTap: null,
                            text: "Update Profile",
                          ),
                          SecondaryButton(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 4,
                            ),
                            borderRadius: 40,
                            backgroundColor: AppColors.redColor,
                            onTap: () {},
                            text: "Log Out",
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AllergicItemChips extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const AllergicItemChips({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 6, top: 6, bottom: 6),
      margin: EdgeInsets.only(right: 10, top: 5, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.redColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        spacing: 3,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: AppTextStyles.normalText.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SecondaryIconButton(
            icon: LucideIcons.circle_x,
            onTap: onTap,
            iconColor: AppColors.whiteColor,
          ),
        ],
      ),
    );
  }
}
