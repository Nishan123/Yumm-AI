import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/custom_divider.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/core/widgets/custom_text_button.dart';
import 'package:yumm_ai/core/widgets/primary_button.dart';
import 'package:yumm_ai/core/widgets/svg_text_logo.dart';
import 'package:yumm_ai/features/auth/presentation/state/auth_state.dart';
import 'package:yumm_ai/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:yumm_ai/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:yumm_ai/features/auth/presentation/widgets/google_signin_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _emailController = TextEditingController(text:"jamal@gmail.com");
  final TextEditingController _passwordController = TextEditingController(text:"Nishan@123");
  final TextEditingController _confirmPasswordController =
      TextEditingController(text:"Nishan@123");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordObscure = true;
  bool _isConfirmObscure = true;

  Future<void> _onSignup() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      CustomSnackBar.showErrorSnackBar(
        context,
        "Confirm password did not match",
      );
      return;
    }
    await ref
        .read(authViewModelProvider.notifier)
        .signup(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          fullName: _emailController.text.trim().split('@').first,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        CustomSnackBar.showErrorSnackBar(context, next.errorMessage!);
      } else if (next.status == AuthStatus.registered) {
        CustomSnackBar.showSuccessSnackBar(
          context,
          "Registered Successfully! Please Login",
        );
        context.goNamed('login');
      }
    });
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 18),
          child: LayoutBuilder(
            builder: (context, constrains) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constrains.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 20,
                        children: [
                          SizedBox(height: 30),

                          Spacer(),
                          SvgTextLogo(),
                          SizedBox(height: 10),
                          Text("Sign Up !", style: AppTextStyles.h1),
                          AuthTextField(
                            inputType: TextInputType.emailAddress,
                            prefixIcon: LucideIcons.circle_user,
                            hintText: "Email",
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Email";
                              } else {
                                return null;
                              }
                            },
                          ),
                          AuthTextField(
                            isPassword: true,
                            isObscure: _isPasswordObscure,
                            onShowPassword: () {
                              setState(() {
                                _isPasswordObscure = !_isPasswordObscure;
                              });
                            },
                            suffixIcon: _isPasswordObscure
                                ? LucideIcons.eye
                                : LucideIcons.eye_off,
                            prefixIcon: LucideIcons.lock,
                            hintText: "Password",
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Password";
                              } else if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),
                          AuthTextField(
                            isPassword: true,
                            isObscure: _isConfirmObscure,
                            onShowPassword: () {
                              setState(() {
                                _isConfirmObscure = !_isConfirmObscure;
                              });
                            },
                            suffixIcon: _isConfirmObscure
                                ? LucideIcons.eye
                                : LucideIcons.eye_off,
                            prefixIcon: LucideIcons.lock,
                            hintText: "Confirm Password",
                            controller: _confirmPasswordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Confirm Password";
                              } else {
                                return null;
                              }
                            },
                          ),

                          Spacer(),

                          PrimaryButton(
                            onTap: _onSignup,
                            text: "Sign Up",
                            isLoading: authState.status == AuthStatus.loading,
                          ),
                          CustomDivider(),

                          GoogleSigninButton(
                            onTap: () {},
                            text: "Sign Up with Google",
                          ),

                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?  ",
                                style: AppTextStyles.h6,
                              ),
                              CustomTextButton(
                                text: "Log In",
                                onTap: () {
                                  context.goNamed("login");
                                },
                                textColor: AppColors.blueColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
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
