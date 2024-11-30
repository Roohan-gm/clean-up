import 'package:clean_up/features/screens/login/login.dart';
import 'package:clean_up/utils/constants/sizes.dart';
import 'package:clean_up/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/helper_function.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(RSizes.defaultSpacing),
          child: Column(
            children: [
              /// Image
              Image(
                image: const AssetImage(RImages.successIllustration),
                width: RHelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(
                height: RSizes.spaceBtwSection,
              ),

              /// Title & Subtitle
              Text(
                RTexts.changePasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: RSizes.spaceBtwItems,
              ),
              Text(
                RTexts.changePasswordSubtitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: RSizes.spaceBtwSection,
              ),

              /// Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>Get.off(() => const LoginScreen()),
                  child: const Text(RTexts.done),
                ),
              ),
              const SizedBox(
                height: RSizes.spaceBtwItems,
              ),

              /// Buttons
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: (){},
                  child: const Text(RTexts.resendEmail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
