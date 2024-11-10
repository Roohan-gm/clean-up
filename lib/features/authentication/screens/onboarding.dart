import 'package:clean_up/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../../utils/constants//text_strings.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      /// Horizontal Scrollable Pages
      PageView(
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
      // Positioned(top: RDeviceUtils.getAppBarHeight(), right: RSizes.defaultSpace,child: TextButton(onPressed:(){}, child: const Text('Skip'))),
      /// Dot Navigation  SmoothPageIndicator
      ///
      /// Circular Button
    ]));
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final String image, title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(RSizes.defaultSpacing),
      child: Column(children: [
        Image(
          image: AssetImage(image),
          width: RHelperFunctions.screenWidth() * 0.8,
          height: RHelperFunctions.screenWidth() * 0.6,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: RSizes.spaceBtwItems,
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}
