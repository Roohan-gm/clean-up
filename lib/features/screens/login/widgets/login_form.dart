import 'package:clean_up/features/screens/home/home.dart';
import 'package:clean_up/features/screens/password_configuration/forget_password.dart';
import 'package:clean_up/features/screens/signup/signup.dart';
import 'package:clean_up/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class RLoginForm extends StatefulWidget {
  const RLoginForm({
    super.key,
  });

  @override
  State<RLoginForm> createState() => _RLoginFormState();
}

class _RLoginFormState extends State<RLoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  final _rememberMe = false.obs;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading.value = true);

      try {
        final response = await Supabase.instance.client.auth.signInWithPassword(
            password: _passwordController.text.trim(), email: _emailController.text.trim());
        if (response.session != null) {
          Get.snackbar('Success', "You are logged in!");
          _resetForm();
          Get.offAll(() => const HomeScreen());
        } else {
          Get.snackbar('Error', 'Invalid credentials.');
        }
      } catch (e) {
        Get.snackbar('Error', e.toString());
      } finally {
        setState(() => _isLoading.value = false);
      }
    }
  }

  void _resetForm() {
    _emailController.clear();
    _passwordController.clear();
    _rememberMe.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: RSizes.spaceBtwSection),
          child: Column(
            children: [
              /// Email
              _BuildEmailField(emailController: _emailController),

              const SizedBox(
                height: RSizes.spaceBtwInputField,
              ),

              /// Password
              PasswordField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                toggleObscureText: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),

              const SizedBox(
                height: RSizes.spaceBtwInputField / 2,
              ),

              /// Remember Me & Forget Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Remember Me
                  Row(
                    children: [
                      Checkbox(
                          value: _rememberMe.value,
                          onChanged: (value) =>
                              setState(() => _rememberMe.value = value!)),
                      const Text(RTexts.rememberMe),
                    ],
                  ),

                  /// Forget Password
                  TextButton(
                      onPressed: () => Get.to(() => const ForgetPassword()),
                      child: const Text(RTexts.forgetPassword))
                ],
              ),
              const SizedBox(
                height: RSizes.spaceBtwSection,
              ),

              /// Sign In Button
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _isLoading.value ? null : _login,
                      child: _isLoading.value
                          ? const CircularProgressIndicator(
                              color: RColors.white,
                            )
                          : const Text(RTexts.signIn))),
              const SizedBox(
                height: RSizes.spaceBtwItems,
              ),

              /// Create Account Button
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () => Get.to(() => const SignupScreen()),
                      child: const Text(RTexts.createAccount))),
              const SizedBox(
                height: RSizes.spaceBtwSection,
              ),
            ],
          ),
        ));
  }
}

class _BuildEmailField extends StatelessWidget {
  const _BuildEmailField({
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        autocorrect: false,
        enableSuggestions: false,
        decoration: const InputDecoration(
          prefixIcon: Icon(Iconsax.direct_right),
          labelText: RTexts.email,
        ),
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email cannot be empty';
          }
          final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
          return !emailRegex.hasMatch(value)
              ? 'Enter a valid email address'
              : null;
        });
  }
}

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback toggleObscureText;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.toggleObscureText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        prefixIcon: const Icon(Iconsax.password_check),
        labelText: RTexts.password,
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Iconsax.eye_slash : Iconsax.eye),
          onPressed: toggleObscureText,
        ),
      ),
      controller: controller,
      keyboardType: TextInputType.visiblePassword,
      validator: validator ??
          (value) => value == null || value.length < 8
              ? 'Password must be at least 8 characters'
              : null,
    );
  }
}
