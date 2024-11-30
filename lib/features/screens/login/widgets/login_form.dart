import 'package:clean_up/features/screens/home/home.dart';
import 'package:clean_up/features/screens/password_configuration/forget_password.dart';
import 'package:clean_up/features/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../app_controller.dart';

class RLoginForm extends StatelessWidget {
  const RLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    return Form(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: RSizes.spaceBtwSection),
      child: Column(
        children: [
          /// Email
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.direct_right),
              labelText: RTexts.email,
            ),
          ),

          const SizedBox(
            height: RSizes.spaceBtwInputField,
          ),

          /// Password
          TextFormField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: RTexts.password,
                suffixIcon: Icon(Iconsax.eye_slash)),
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
                  Checkbox(value: true, onChanged: (value) {}),
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
                  onPressed: () => appController.login,
                  child: const Text(RTexts.signIn))),
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
