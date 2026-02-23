import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/core/widgets/custom_text_button.dart';
import 'package:yumm_ai/core/widgets/primary_button.dart';
import 'package:yumm_ai/core/widgets/svg_text_logo.dart';
import 'package:yumm_ai/features/auth/presentation/state/auth_state.dart';
import 'package:yumm_ai/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:yumm_ai/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _onSendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authViewModelProvider.notifier)
        .forgotPassword(email: _emailController.text.trim());

    if (success && mounted) {
      CustomSnackBar.showSuccessSnackBar(
        context,
        "Reset link sent! Check your email.",
      );
      _emailController.clear();
    }
    // Error is handled by listening to view_model state if needed,
    // or we could show it here.
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        CustomSnackBar.showErrorSnackBar(context, next.errorMessage!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        constraints.maxHeight -
                        Scaffold.of(context).appBarMaxHeight!,
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Center(child: SvgTextLogo()),
                          const SizedBox(height: 30),
                          const Text(
                            "Forgot\nPassword?",
                            style: AppTextStyles.h1,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Don't worry! It occurs. Please enter the email address linked with your account.",
                            style: AppTextStyles.h6.copyWith(
                              color: AppColors.descriptionTextColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          AuthTextField(
                            inputType: TextInputType.emailAddress,
                            prefixIcon: LucideIcons.mail,
                            hintText: "Enter your email",
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Email";
                              } else if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          PrimaryButton(
                            text: "Send Reset Link",
                            onTap: _onSendResetLink,
                            isLoading:
                                authState.status ==
                                AuthStatus.emailPasswordLoading,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Remember password?  ",
                                style: AppTextStyles.h6,
                              ),
                              CustomTextButton(
                                text: "Log in",
                                onTap: () {
                                  context.pop();
                                },
                                textColor: AppColors.blueColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
