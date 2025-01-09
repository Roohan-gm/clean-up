import 'package:clean_up/features/controllers/login/login_controller.dart';
import 'package:clean_up/features/screens/password_configuration/forget_password.dart';
import 'package:clean_up/features/screens/signup/signup.dart';
import 'package:clean_up/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class RLoginForm extends StatelessWidget {
  const RLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: RSizes.spaceBtwSection),
        child: Column(
          children: [
            /// Email
            TextFormField(
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: RTexts.email,
                ),
                controller: controller.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => RValidator.validateEmail(value)),

            const SizedBox(
              height: RSizes.spaceBtwInputField,
            ),

            /// Password
            Obx(
              () => TextFormField(
                autocorrect: false,
                enableSuggestions: false,
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  labelText: RTexts.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    icon: Icon(controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye),
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                  ),
                ),
                controller: controller.password,
                validator: (value) =>
                    RValidator.validateEmptyText('Password', value),
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            const SizedBox(
              height: RSizes.spaceBtwInputField / 2,
            ),

            /// Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember Me
                Row(children: [
                  Obx(() => Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: (value) => controller.rememberMe.value =
                          !controller.rememberMe.value)),
                  const Text(RTexts.rememberMe),
                ]),

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
                    onPressed: () => controller.emailAndPasswordSignIn(),
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
      ),
    );
  }
}
