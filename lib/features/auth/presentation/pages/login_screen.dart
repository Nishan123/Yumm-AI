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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordObscure = true;

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authViewModelProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        CustomSnackBar.showErrorSnackBar(context, next.errorMessage!);
      } else if (next.status == AuthStatus.authenticated) {
        context.goNamed("main");
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
                          SizedBox(height: 15),
                          Text("Welcome\nBack !", style: AppTextStyles.h1),
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
                              } else {
                                return null;
                              }
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomTextButton(
                                text: "Forget Password?",
                                onTap: () {},
                              ),
                            ],
                          ),
                          Spacer(),

                          PrimaryButton(
                            text: "Log In",
                            onTap: _onLogin,
                            isLoading: authState.status == AuthStatus.loading,
                          ),
                          CustomDivider(),
                          GoogleSigninButton(
                            onTap: () {},
                            text: "Sign In With Google",
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?  ",
                                style: AppTextStyles.h6,
                              ),
                              CustomTextButton(
                                text: "Create one",
                                onTap: () {
                                  context.pushNamed("signup");
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
