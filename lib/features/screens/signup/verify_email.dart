import 'package:clean_up/features/screens/login/login.dart';
import 'package:clean_up/utils/constants/sizes.dart';
import 'package:clean_up/utils/helpers/helper_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () => Get.offAll(() => const LoginScreen()),
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
                  image: const AssetImage(RImages.verificationIllustration),
                  width: RHelperFunctions.screenWidth() * 0.6,
                ),
                const SizedBox(
                  height: RSizes.spaceBtwSection,
                ),

                /// Title & Subtitle
                Text(
                  RTexts.confirmEmail,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: RSizes.spaceBtwItems,
                ),
                Text(
                  'rgs',
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: RSizes.spaceBtwItems,
                ),
                Text(
                  RTexts.confirmEmailSubtitle,
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
                    onPressed: () {},
                    child: const Text(RTexts.rContinue),
                  ),
                ),
                const SizedBox(
                  height: RSizes.spaceBtwItems,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(RTexts.resendEmail),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
