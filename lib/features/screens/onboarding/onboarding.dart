import 'package:clean_up/features/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:clean_up/features/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:clean_up/features/screens/onboarding/widgets/onboarding_page.dart';
import 'package:clean_up/features/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';

import '../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
        body: Stack(children: [
      /// Horizontal Scrollable Pages
      PageView(
        controller: controller.pageController,
        onPageChanged: controller.updatePageIndicator,
        children: const [
          OnBoardingPage(
            image: RImages.onboardingScreen1,
            title: RTexts.onBoardingTitle1,
            subtitle: RTexts.onBoardingSubTitle1,
          ),
          OnBoardingPage(
            image: RImages.onboardingScreen2,
            title: RTexts.onBoardingTitle2,
            subtitle: RTexts.onBoardingSubTitle2,
          ),
          OnBoardingPage(
            image: RImages.onboardingScreen3,
            title: RTexts.onBoardingTitle3,
            subtitle: RTexts.onBoardingSubTitle3,
          ),
        ],
      ),

      /// Skip Button
      const OnBoardingSkip(),

      /// Dot Navigation  SmoothPageIndicator
      const OnBoardingDotNavigation(),

      /// Circular Button
      const OnBoardingNextButton()
    ]));
  }
}
