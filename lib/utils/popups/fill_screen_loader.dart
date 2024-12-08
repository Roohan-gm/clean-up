import 'package:clean_up/utils/constants/colors.dart';
import 'package:clean_up/utils/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/animation_loader.dart';

/// A utility class for managing a full-screen loading dialog.
class RFullScreenLoader {
  /// open a full-screen loading dialog with a given text and animation.
  /// This method doesn't return anything.
  ///
  /// Parameters:
  ///   - text: The text to be displayed in the loading dialog.
  ///   - animation: The Lottie animation to be shown.
  static void openLoadingDialog(String text, String animation) {
    showDialog(
        context: Get.overlayContext!,
        // Use Get.overlayContext for overlay dialogs
        barrierDismissible: false,
        //The dialog can't be dismissed by taping outside it.
        builder: (_) => PopScope(
            canPop: false,
            child: Container(
              color: RHelperFunctions.isDarkMode(Get.context!)
                  ? RColors.dark
                  : RColors.white,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RAnimationLoaderWidget(text: text, animation: animation)
                ],
              ),
            )
        )
    );
  }

  /// Stop the currently open loading dialog.
  /// This method doesn't return anything.
  static stopLoading(){
    Navigator.of(Get.overlayContext!).pop(); // close the dialog using the Navigator
  }
}
