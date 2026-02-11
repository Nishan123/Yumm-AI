import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/widgets/check_lists_drop_down.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/core/widgets/custom_text_button.dart';
import 'package:yumm_ai/core/widgets/primary_text_field.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/features/profile/presentation/state/delete_profile_state.dart';
import 'package:yumm_ai/features/profile/presentation/view_model/delete_profile_view_model.dart';

class DeleteProfileScreen extends ConsumerStatefulWidget {
  const DeleteProfileScreen({super.key});

  @override
  ConsumerState<DeleteProfileScreen> createState() =>
      _DeleteProfileScreenState();
}

class _DeleteProfileScreenState extends ConsumerState<DeleteProfileScreen> {
  final passwordController = TextEditingController();
  final deletionReasonsOptions = [
    "Not using app anymore.",
    "I found better alternative.",
    "This app contains too many bugs.",
    "This app didn't have the features or functionaly was looking for,",
    "I'm not satisfied with the app's quality",
    "This app is difficult to use",
    "Others",
  ];
  List<String> selectedOptions = [];
  bool isAgreed = false;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.value;
    final deleteProfileState = ref.watch(deleteProfileViewModelProvider);

    // Listen to state changes for showing snackbars and navigation
    ref.listen<DeleteProfileState>(deleteProfileViewModelProvider, (
      previous,
      next,
    ) {
      if (next.status == DeleteProfileStatus.error &&
          next.errorMessage != null) {
        CustomSnackBar.showErrorSnackBar(context, next.errorMessage!);
      } else if (next.status == DeleteProfileStatus.success) {
        CustomSnackBar.showSuccessSnackBar(
          context,
          next.successMessage ?? "Account deleted successfully",
        );
        // Navigate to login screen after successful deletion
        context.go('/login');
      }
    });

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final authProvider = user.authProvider;
    final isAuthEmailPass = authProvider == "emailPassword";
    final isLoading = deleteProfileState.status == DeleteProfileStatus.loading;

    return Scaffold(
      appBar: AppBar(title: Text("Delete your profile")),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: IntrinsicHeight(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isAuthEmailPass) ...[
                            Text(
                              "Enter your password to delete your account.",
                              style: AppTextStyles.descriptionText,
                            ),
                            const SizedBox(height: 12),
                            PrimaryTextField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter Password to continue";
                                }
                                return null;
                              },
                              hintText: "Your Password",
                              controller: passwordController,
                            ),
                          ] else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Google_Favicon_2025.svg/1024px-Google_Favicon_2025.svg.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        "Logged in via Google account",
                                        style: AppTextStyles.h6.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "You will be asked to verify your Google account before deletion.",
                                    style: AppTextStyles.descriptionText
                                        .copyWith(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 14),

                          // Reasons Checklist dropdown
                          CustomDropdownChecklist(
                            margin: EdgeInsets.all(0),
                            title: "Reasons you decided to leave",
                            options: deletionReasonsOptions,
                            selectedOptions: selectedOptions,
                            onConfirm: (values) {
                              setState(() {
                                selectedOptions = values;
                              });
                            },
                          ),

                          const SizedBox(height: 24),

                          // Warning text
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.redColor.withAlpha(8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.redColor.withAlpha(40),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: AppColors.redColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Warning",
                                      style: AppTextStyles.h6.copyWith(
                                        color: AppColors.redColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Deleting your account is permanent and cannot be undone. All your data will be permanently erased. By proceeding, you will lose access to your account immediately.",
                                  style: AppTextStyles.descriptionText.copyWith(
                                    color: AppColors.redColor.withAlpha(200),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isAgreed = !isAgreed;
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,

                                children: [
                                  Container(
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                      color: isAgreed
                                          ? AppColors.redColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isAgreed
                                            ? AppColors.redColor
                                            : Colors.grey.shade400,
                                        width: 2,
                                      ),
                                    ),
                                    child: isAgreed
                                        ? const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "I agree to the terms and conditions of deleting my account.",
                                      style: AppTextStyles.normalText.copyWith(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Spacer(),
                          const SizedBox(height: 24),

                          SecondaryButton(
                            margin: EdgeInsets.all(0),
                            borderRadius: 30,
                            backgroundColor: AppColors.redColor,
                            isLoading: isLoading,
                            onTap: (isAgreed && !isLoading)
                                ? () => _handleDeleteAccount(
                                    isAuthEmailPass: isAuthEmailPass,
                                    uid: user.uid!,
                                  )
                                : null,
                            text: "Confirm Delete",
                          ),
                          const SizedBox(height: 24),
                          if (!isLoading)
                            Center(
                              child: CustomTextButton(
                                text: "Go Back",
                                onTap: () => context.pop(),
                                buttonTextStyle: AppTextStyles.h3.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
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

  void _handleDeleteAccount({
    required bool isAuthEmailPass,
    required String uid,
  }) {
    // Validate that at least one reason is selected
    if (selectedOptions.isEmpty) {
      CustomSnackBar.showErrorSnackBar(context, "Select atleast one reason");
      return;
    }

    final viewModel = ref.read(deleteProfileViewModelProvider.notifier);

    if (isAuthEmailPass) {
      // Validate the form (password field)
      if (formKey.currentState!.validate()) {
        viewModel.deleteWithPassword(
          uid: uid,
          password: passwordController.text,
        );
      }
    } else {
      // For Google auth users, trigger Google re-authentication flow
      viewModel.deleteWithGoogle(uid: uid);
    }
  }
}
