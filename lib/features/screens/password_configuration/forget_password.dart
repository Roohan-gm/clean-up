import 'package:clean_up/features/controllers/forget_password/forget_password_controller.dart';
import 'package:clean_up/utils/constants/sizes.dart';
import 'package:clean_up/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/text_strings.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(RSizes.defaultSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Headings
              Text(
                RTexts.forgetPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: RSizes.spaceBtwItems,
              ),
              Text(
                RTexts.forgetPasswordSubtitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: RSizes.spaceBtwSection * 2,
              ),

              /// Text field
              Form(
                key: controller.forgetPasswordFormKey,
                child: TextFormField(
                  controller: controller.email,
                  validator: RValidator.validateEmail,
                  decoration: const InputDecoration(
                      labelText: RTexts.email,
                      prefixIcon: Icon(Iconsax.direct_right)),
                ),
              ),
              const SizedBox(
                height: RSizes.spaceBtwSection,
              ),

              /// Submit Button
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => controller.sendPasswordResetEmail(),
                      child: const Text(RTexts.submit)))
            ],
          ),
        ));
  }
}
