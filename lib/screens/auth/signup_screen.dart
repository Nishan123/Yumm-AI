import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/screens/auth/widgets/auth_text_field.dart';
import 'package:yumm_ai/screens/auth/widgets/google_signin_button.dart';
import 'package:yumm_ai/widgets/custom_divider.dart';
import 'package:yumm_ai/widgets/custom_text_button.dart';
import 'package:yumm_ai/widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordObscure = true;
  bool _isConfirmObscure = true;
  @override
  Widget build(BuildContext context) {
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 24,
                      children: [
                        SizedBox(height: 50),
                        Spacer(),
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
                            } else {
                              return null;
                            }
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
                          text: "Sign Up",
                          backgroundColor: AppColors.primaryColor,
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
                                // context.pop();
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
              );
            },
          ),
        ),
      ),
    );
  }
}
