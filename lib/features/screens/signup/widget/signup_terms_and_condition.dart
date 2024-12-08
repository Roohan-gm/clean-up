import 'package:clean_up/features/controllers/signup/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_function.dart';

class SignupTermsAndCondition extends StatelessWidget {
  const SignupTermsAndCondition({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = RHelperFunctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox(
            width: 24,
            height: 24,
            child: Obx(() => Checkbox(
                value: controller.privacyPolicy.value,
                onChanged: (value) => controller.privacyPolicy.value =
                    !controller.privacyPolicy.value))),
        const SizedBox(
          height: RSizes.spaceBtwItems,
        ),
        Text.rich(TextSpan(children: [
          TextSpan(
              text: '${RTexts.iAgreeTo} ',
              style: Theme.of(context).textTheme.bodySmall),
          TextSpan(
              text: '${RTexts.privacyPolicy} ',
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: dark ? RColors.textWhite : RColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: dark ? RColors.textWhite : RColors.primary,
                  )),
          TextSpan(
              text: '${RTexts.and} ',
              style: Theme.of(context).textTheme.bodySmall),
          TextSpan(
              text: RTexts.termsOfUse,
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: dark ? RColors.textWhite : RColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: dark ? RColors.textWhite : RColors.primary,
                  )),
        ]))
      ],
    );
  }
}
