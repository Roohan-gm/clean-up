import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class RLoadersSnackBar {
  /// SUCCESS
  static void successSnackBar({required String title, String message = ''}) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.transparent,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      dismissDirection: DismissDirection.horizontal,
      padding: EdgeInsets.zero,
      messageText: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.success,
      ),
    ));
  }

  /// ERROR
  static void errorSnackBar({required String title, String message = ''}) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.transparent,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      dismissDirection: DismissDirection.horizontal,
      padding: EdgeInsets.zero,
      messageText: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.failure,
      ),
    ));
  }

  /// WARNING
  static void warningSnackBar({required String title, String message = ''}) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.transparent,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      dismissDirection: DismissDirection.horizontal,
      padding: EdgeInsets.zero,
      messageText: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.warning,
      ),
    ));
  }

  /// INFO
  static void infoSnackBar({required String title, String message = ''}) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.transparent,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      dismissDirection: DismissDirection.horizontal,
      padding: EdgeInsets.zero,
      messageText: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.help,
      ),
    ));
  }

// static successSnackBar({required title, message = '', duration = 3}) {
  //   Get.snackbar(title, message,
  //       isDismissible: true,
  //       shouldIconPulse: true,
  //       colorText: RColors.white,
  //       backgroundColor: RColors.primary,
  //       snackPosition: SnackPosition.BOTTOM,
  //       duration: Duration(seconds: duration),
  //       margin: const EdgeInsets.all(10),
  //       icon: const Icon(
  //         Iconsax.check,
  //         color: RColors.white,
  //       ));
  // }


}
