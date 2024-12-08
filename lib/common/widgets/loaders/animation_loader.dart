import 'package:clean_up/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/constants/sizes.dart';

/// A widget for displaying an animation loading indicator with optional text and action button.
class RAnimationLoaderWidget extends StatelessWidget {
  /// Default constructor for the RAnimationLoaderWidget.
  ///
  /// Parameters:
  ///     - test: The text to be displayed below the animation.
  ///     - animation: The path to the Lottie animation file.
  ///     _ showAction: Whether to show an action button.
  ///     _ actionText: The text to displayed on the action button.
  ///     _ onActionPressed: Callback function to be executed when the action button is pressed.
  const RAnimationLoaderWidget({
    super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
  });

  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(animation,
            fit: BoxFit.contain,
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width *
                0.8), // Display Lotte animation
        const SizedBox(
          height: RSizes.defaultSpacing,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: RSizes.defaultSpacing,
        ),
        showAction
            ? SizedBox(
                width: 250,
                child: OutlinedButton(
                    onPressed: onActionPressed,
                    style:
                        OutlinedButton.styleFrom(backgroundColor: RColors.dark),
                    child: Text(
                      actionText!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: RColors.light),
                    )))
            : const SizedBox()
      ],
    );
  }
}
