import 'package:clean_up/features/controllers/signup/signup_controller.dart';
import 'package:clean_up/features/screens/signup/widget/signup_terms_and_condition.dart';
import 'package:clean_up/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class RSignupForm extends StatelessWidget {
  const RSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
        key: controller.signupFormKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    expands: false,
                    decoration: const InputDecoration(
                        labelText: RTexts.firstName,
                        prefixIcon: Icon(Iconsax.user)),
                    controller: controller.firstName,
                    validator: (value) =>
                        RValidator.validateEmptyText('First name', value),
                    keyboardType: TextInputType.name,
                  ),
                ),
                const SizedBox(
                  width: RSizes.spaceBtwInputField,
                ),
                Expanded(
                  child: TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    expands: false,
                    decoration: const InputDecoration(
                        labelText: RTexts.lastName,
                        prefixIcon: Icon(Iconsax.user)),
                    controller: controller.lastName,
                    validator: (value) =>
                        RValidator.validateEmptyText('Last name', value),
                    keyboardType: TextInputType.name,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: RSizes.spaceBtwInputField,
            ),

            /// Username
            TextFormField(
              autocorrect: false,
              enableSuggestions: false,
              expands: false,
              decoration: const InputDecoration(
                  labelText: RTexts.username,
                  prefixIcon: Icon(Iconsax.user_edit)),
              controller: controller.userName,
              validator: (value) =>
                  RValidator.validateEmptyText('username', value),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: RSizes.spaceBtwInputField,
            ),

            /// Email
            TextFormField(
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                  labelText: RTexts.email, prefixIcon: Icon(Iconsax.direct)),
              controller: controller.email,
              validator: (value) => RValidator.validateEmail(value),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: RSizes.spaceBtwInputField,
            ),

            /// Phone
            TextFormField(
              decoration: const InputDecoration(
                  labelText: RTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
              controller: controller.phoneNumber,
              validator: (value) => RValidator.validatePhoneNumber(value),
              keyboardType: TextInputType.phone,
            ),
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
                validator: (value) => RValidator.validatePassword(value),
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            const SizedBox(
              height: RSizes.spaceBtwInputField,
            ),

            /// Terms & Conditions Checkbox
            const SignupTermsAndCondition(),
            const SizedBox(
              height: RSizes.spaceBtwSection,
            ),

            /// Sign Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller.signup(),
                  child: const Text(RTexts.createAccount)),
            )
          ],
        ));
  }
}
