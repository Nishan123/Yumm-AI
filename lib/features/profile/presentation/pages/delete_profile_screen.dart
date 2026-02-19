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
import 'package:yumm_ai/core/widgets/custom_checkbox_with_text.dart';
import 'package:yumm_ai/core/widgets/google_auth_indicator.dart';
import 'package:yumm_ai/features/profile/presentation/widgets/delete_profile_warning.dart';

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
                            const GoogleAuthIndicator(
                              description:
                                  "I agree to the terms and conditions of deleting my account.",
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
                          const DeleteProfileWarning(),

                          const SizedBox(height: 16),

                          CustomCheckboxWithText(
                            text:
                                "I agree to the terms and conditions of deleting my account.",
                            isAgreed: isAgreed,
                            onChanged: (value) {
                              setState(() {
                                isAgreed = value;
                              });
                            },
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
