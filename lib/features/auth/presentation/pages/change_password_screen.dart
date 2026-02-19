import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/core/widgets/google_auth_indicator.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/features/auth/presentation/state/change_password_state.dart';
import 'package:yumm_ai/features/auth/presentation/view_model/change_password_view_model.dart';
import 'package:yumm_ai/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:yumm_ai/features/auth/presentation/view_model/auth_view_model.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _bottomSheetFormKey = GlobalKey<FormState>();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(currentUserProvider);
    final viewModelState = ref.watch(changePasswordViewModelProvider);

    ref.listen<ChangePasswordState>(changePasswordViewModelProvider, (
      previous,
      next,
    ) {
      if (next.status == ChangePasswordStatus.oldPasswordVerified) {
        _showNewPasswordBottomSheet(context);
      } else if (next.status ==
          ChangePasswordStatus.oldPasswordVerificationFailed) {
        if (next.errorMessage != null) {
          CustomSnackBar.showErrorSnackBar(context, next.errorMessage!);
        }
      } else if (next.status == ChangePasswordStatus.changePasswordSuccess) {
        Navigator.pop(context); // Close bottom sheet
        CustomSnackBar.showSuccessSnackBar(
          context,
          "Password changed successfully",
        );
        ref.read(changePasswordViewModelProvider.notifier).resetState();
        ref.read(authViewModelProvider.notifier).logout();
      } else if (next.status == ChangePasswordStatus.changePasswordFailed) {
        if (next.errorMessage != null) {
          CustomSnackBar.showErrorSnackBar(context, next.errorMessage!);
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: userState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text("User not found"));
          }

          if (user.authProvider != 'emailPassword') {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GoogleAuthIndicator(description: "You cannot change your password if you are logged in via Google account"),
              )
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Verify it's you",
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.descriptionTextColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Enter your current password to continue.",
                    style: AppTextStyles.descriptionText,
                  ),
                  const SizedBox(height: 20),

                  // Current Password text field
                  AuthTextField(
                    hintText: "Current password",
                    controller: _oldPasswordController,
                    isObscure: !_isCurrentPasswordVisible,
                    isPassword: true,
                    onShowPassword: () {
                      setState(() {
                        _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                      });
                    },
                    suffixIcon: _isCurrentPasswordVisible
                        ? LucideIcons.eye_off
                        : LucideIcons.eye,
                    prefixIcon: LucideIcons.lock,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter current password";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Button
                  SecondaryButton(
                    borderRadius: 60,
                    margin: EdgeInsets.all(0),
                    backgroundColor: AppColors.blueColor,
                    text: "Verify",
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        ref
                            .read(changePasswordViewModelProvider.notifier)
                            .verifyOldPassword(_oldPasswordController.text);
                      }
                    },
                    isLoading:
                        viewModelState.status == ChangePasswordStatus.loading,
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showNewPasswordBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (ctx) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                  left: 16,
                  right: 16,
                  top: 30,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _bottomSheetFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Enter New Password",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // New Password Field
                        AuthTextField(
                          hintText: "New Password",
                          controller: _newPasswordController,
                          isObscure: !_isNewPasswordVisible,
                          isPassword: true,
                          onShowPassword: () {
                            setModalState(() {
                              _isNewPasswordVisible = !_isNewPasswordVisible;
                            });
                          },
                          suffixIcon: _isNewPasswordVisible
                              ? LucideIcons.eye_off
                              : LucideIcons.eye,
                          prefixIcon: LucideIcons.lock,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a new password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Confirm Password Field
                        AuthTextField(
                          hintText: "Confirm New Password",
                          controller: _confirmPasswordController,
                          isObscure: !_isConfirmPasswordVisible,
                          isPassword: true,
                          onShowPassword: () {
                            setModalState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                          suffixIcon: _isConfirmPasswordVisible
                              ? LucideIcons.eye_off
                              : LucideIcons.eye,
                          prefixIcon: LucideIcons.lock,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your new password';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Note: Changing your password will log you out of all devices. You will need to log in again with your new password.",
                          style: AppTextStyles.descriptionText.copyWith(
                            fontSize: 14,
                            color: AppColors.descriptionTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        Consumer(
                          builder: (context, ref, child) {
                            final state = ref.watch(
                              changePasswordViewModelProvider,
                            );
                            return SecondaryButton(
                              borderRadius: 60,
                              margin: const EdgeInsets.all(0),
                              backgroundColor: AppColors.blueColor,
                              text: "Change Password",
                              isLoading:
                                  state.status == ChangePasswordStatus.loading,
                              onTap: () {
                                if (_bottomSheetFormKey.currentState!
                                    .validate()) {
                                  ref
                                      .read(
                                        changePasswordViewModelProvider
                                            .notifier,
                                      )
                                      .changePassword(
                                        oldPassword:
                                            _oldPasswordController.text,
                                        newPassword:
                                            _newPasswordController.text,
                                      );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
