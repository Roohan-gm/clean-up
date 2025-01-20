import 'package:clean_up/data/repositories/authentication/authentication_repository.dart';
import 'package:clean_up/features/screens/password_configuration/reset_password.dart';
import 'package:clean_up/utils/http/network_manager.dart';
import 'package:clean_up/utils/popups/fill_screen_loader.dart';
import 'package:clean_up/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../utils/constants/image_strings.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  ///Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  /// Send Reset Password Email
  sendPasswordResetEmail() async {
    try {
      // Start Loading
      RFullScreenLoader.openLoadingDialog(
          'Processing your request...', RImages.lottieAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        RFullScreenLoader.stopLoading();
        return;
      }
      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // Send Email to reset Password
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      // Remove Loader
      RFullScreenLoader.stopLoading();

      // Show Success Screen
      RLoadersSnackBar.successSnackBar(
          title: 'Email Sent',
          message: 'Email link sent to reset your password'.tr);

      // Redirect
      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      // Remove Loader
      RFullScreenLoader.stopLoading();
      RLoadersSnackBar.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  /// Resend Reset Password Email
  resendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      RFullScreenLoader.openLoadingDialog(
          'Processing your request...', RImages.lottieAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // Send Email to reset Password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      // Remove Loader
      RFullScreenLoader.stopLoading();

      // Show Success Screen
      RLoadersSnackBar.successSnackBar(
          title: 'Email Sent',
          message: 'Email link sent to reset your password'.tr);
    } catch (e) {
      // Remove Loader
      RFullScreenLoader.stopLoading();
      RLoadersSnackBar.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
