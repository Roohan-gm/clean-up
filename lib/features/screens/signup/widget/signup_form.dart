import 'package:clean_up/features/screens/signup/verify_email.dart';
import 'package:clean_up/features/screens/signup/widget/signup_terms_and_condition.dart';
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
    return Form(
        child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                expands: false,
                decoration: const InputDecoration(
                    labelText: RTexts.firstName,
                    prefixIcon: Icon(Iconsax.user)),
              ),
            ),
            const SizedBox(
              width: RSizes.spaceBtwInputField,
            ),
            Expanded(
              child: TextFormField(
                expands: false,
                decoration: const InputDecoration(
                    labelText: RTexts.lastName, prefixIcon: Icon(Iconsax.user)),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: RSizes.spaceBtwInputField,
        ),

        /// Username
        TextFormField(
          expands: false,
          decoration: const InputDecoration(
              labelText: RTexts.username, prefixIcon: Icon(Iconsax.user_edit)),
        ),
        const SizedBox(
          height: RSizes.spaceBtwInputField,
        ),

        /// Email
        TextFormField(
          decoration: const InputDecoration(
              labelText: RTexts.email, prefixIcon: Icon(Iconsax.direct)),
        ),
        const SizedBox(
          height: RSizes.spaceBtwInputField,
        ),

        /// Phone
        TextFormField(
          decoration: const InputDecoration(
              labelText: RTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
        ),
        const SizedBox(
          height: RSizes.spaceBtwInputField,
        ),

        /// Password
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: RTexts.password,
            prefixIcon: Icon(Iconsax.password_check),
            suffixIcon: Icon(Iconsax.eye_slash),
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
              onPressed: () => Get.to(() =>const VerifyEmailScreen() ), child: const Text(RTexts.createAccount)),
        )
      ],
    ));
  }
}
