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
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/core/widgets/input_widget_title.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/core/widgets/secondary_icon_button.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/add_ingredients_bottom_sheet.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_wrap_container.dart';
import 'package:yumm_ai/features/profile/presentation/state/profile_screen_state.dart';
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
  List<IngredientModel> _selectedIngredients = [];
  bool _isInitialized = false;
  bool _areAllergiesInitialized = false;
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedProfilePic;

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
      setState(() {
        _selectedProfilePic = File(photo.path);
      });
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedProfilePic = File(image.path);
        });
      }
    } catch (e) {
      debugPrint("Failed to update profile pic");
    }
  }

  @override
  void initState() {
    super.initState();
    userNameController.addListener(() {
      setState(() {});
    });
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

    if (!_areAllergiesInitialized) {
      final userAsync = ref.read(currentUserProvider);
      userAsync.whenData((user) {
        if (user != null) {
          _selectedIngredients = (user.allergicTo ?? [])
              .map(
                (name) => IngredientModel(
                  ingredientId: name,
                  name: name,
                  imageUrl: '',
                  quantity: '',
                  unit: '',
                  isReady: false,
                ),
              )
              .toList();
          _areAllergiesInitialized = true;
        }
      });
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
    final existingUser = ref.watch(currentUserProvider);
    final state = ref.watch(profileViewModelProvider);

    ref.listen(currentUserProvider, (previous, next) {
      next.whenData((user) {
        if (user != null && !_areAllergiesInitialized) {
          setState(() {
            _selectedIngredients = (user.allergicTo ?? [])
                .map(
                  (name) => IngredientModel(
                    ingredientId: name,
                    name: name,
                    imageUrl: '',
                    quantity: '',
                    unit: '',
                    isReady: false,
                  ),
                )
                .toList();
            _areAllergiesInitialized = true;
          });
        }
      });
    });

    ref.listen(profileViewModelProvider, (previous, next) {
      if (next.profileState == ProfileStates.error &&
          next.errorMsg != null &&
          next.errorMsg != previous?.errorMsg) {
        CustomSnackBar.showErrorSnackBar(context, next.errorMsg!);
      }
      if (next.profileState == ProfileStates.success &&
          next.message != null &&
          next.message != previous?.message) {
        CustomSnackBar.showSuccessSnackBar(context, next.message!);
        setState(() {
          _selectedProfilePic = null;
        });
      }
    });

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
                            selectedImage: _selectedProfilePic,
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
                            haveActionButton: true,
                            title: "You are allergic to :",
                            actionButtonText: "Add Item",
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            onActionTap: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return AddIngredientsBottomSheet(
                                    title: "Search ingredients",
                                    selectedIngredients: _selectedIngredients,
                                    onSubmit:
                                        (List<IngredientModel> newSelection) {
                                          setState(() {
                                            _selectedIngredients = newSelection;
                                          });
                                        },
                                  );
                                },
                              );
                            },
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
                                    selectedIngredients: _selectedIngredients,
                                    onSubmit:
                                        (List<IngredientModel> newSelection) {
                                          setState(() {
                                            _selectedIngredients = newSelection;
                                          });
                                        },
                                  );
                                },
                              );
                            },
                            emptyText: "No Allergic Ingredients",
                            margin: const EdgeInsets.all(0),
                            items: _selectedIngredients
                                .map(
                                  (ing) => AllergicItemChips(
                                    onTap: () {
                                      setState(() {
                                        _selectedIngredients.removeWhere(
                                          (item) =>
                                              item.ingredientId ==
                                              ing.ingredientId,
                                        );
                                      });
                                    },
                                    text: ing.name,
                                  ),
                                )
                                .toList(),
                          ),
                          Spacer(),

                          // Update Profile button
                          Builder(
                            builder: (context) {
                              bool hasChanges = false;
                              existingUser.whenData((data) {
                                if (data != null) {
                                  final currentName = userNameController.text
                                      .trim();
                                  final oldName = data.fullName;
                                  final currentAllergies = _selectedIngredients
                                      .map((e) => e.name)
                                      .toSet();
                                  final oldAllergies = (data.allergicTo ?? [])
                                      .toSet();

                                  if (currentName != oldName ||
                                      !currentAllergies.containsAll(
                                        oldAllergies,
                                      ) ||
                                      !oldAllergies.containsAll(
                                        currentAllergies,
                                      ) ||
                                      _selectedProfilePic != null) {
                                    hasChanges = true;
                                  }
                                }
                              });

                              return SecondaryButton(
                                isLoading: state == ProfileStates.loading,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 4,
                                ),
                                borderRadius: 40,
                                backgroundColor: AppColors.lightBlueColor,
                                onTap: hasChanges
                                    ? () {
                                        existingUser.when(
                                          data: (data) {
                                            if (data == null) {
                                              return CustomSnackBar.showErrorSnackBar(
                                                context,
                                                "Error loading existing user",
                                              );
                                            }
                                            ref
                                                .read(
                                                  profileViewModelProvider
                                                      .notifier,
                                                )
                                                .updateProfile(
                                                  fullName: userNameController
                                                      .text
                                                      .trim(),
                                                  allergicIng:
                                                      _selectedIngredients
                                                          .map((e) => e.name)
                                                          .toList(),
                                                  isSubscribed:
                                                      data.isSubscribedUser!,
                                                  profilePic: data.profilePic!,
                                                  imageFile:
                                                      _selectedProfilePic,
                                                );
                                          },
                                          error: (error, state) {
                                            CustomSnackBar.showErrorSnackBar(
                                              context,
                                              "Error loading existing user",
                                            );
                                          },
                                          loading: () {},
                                        );
                                      }
                                    : null,
                                text: "Update Profile",
                              );
                            },
                          ),

                          // Delete profile Button
                          SecondaryButton(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 4,
                            ),
                            borderRadius: 40,
                            backgroundColor: AppColors.redColor,
                            onTap: () {},
                            text: "Delete Profile",
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
