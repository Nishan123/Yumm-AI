import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/screens/auth/widgets/auth_text_field.dart';
import 'package:yumm_ai/screens/auth/widgets/google_signin_button.dart';
import 'package:yumm_ai/widgets/custom_divider.dart';
import 'package:yumm_ai/widgets/custom_text_button.dart';
import 'package:yumm_ai/widgets/primary_button.dart';
import 'package:yumm_ai/widgets/svg_text_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscure = true;
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
                      spacing: 20,
                      children: [
                        SizedBox(height: 30),
                        Spacer(),
                       SvgTextLogo(),
                        SizedBox(height:15),
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
                          onTap: () {
                            context.goNamed("main");
                          },
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
              );
            },
          ),
        ),
      ),
    );
  }
}
