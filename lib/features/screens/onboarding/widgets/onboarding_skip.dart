import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../../utils/constants/colors.dart';
import '../../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: RDeviceUtils.getAppBarHeight(),
        right: RSizes.defaultSpacing,
        child: TextButton(
            onPressed: () => OnBoardingController.instance.skipPage(),
            child: const Text(
              'Skip',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: RColors.secondary),
            )));
  }
}
