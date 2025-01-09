import 'dart:async';

import 'package:clean_up/common/widgets/success_screen/success_screen.dart';
import 'package:clean_up/utils/constants/image_strings.dart';
import 'package:clean_up/utils/constants/text_strings.dart';
import 'package:clean_up/utils/popups/loaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  /// Send Email Whenever Verify Screen appears & Set Timer for auto redirect.
  @override
  void onInit() {
    RLoadersSnackBar.successSnackBar(
        title: 'Email Sent',
        message: "Please check your inbox and verify your email.");
    setTimerForAutoRedirect();
    super.onInit();
  }

  // /// Send Email Verification link
  void resendEmailVerification() async {
    try {
      final user = Supabase.instance.client.auth.currentSession?.user;

      if (user != null) {
        final response = await Supabase.instance.client.auth
            .updateUser(UserAttributes(email: user.email));
        if (response.user != null) {
          RLoadersSnackBar.successSnackBar(
            title: 'Email Sent',
            message: "Please check your inbox and verify your email.",
          );
        } else {
          RLoadersSnackBar.errorSnackBar(
            title: 'Oh Snap!',
            message: 'Registration failed. Please try again.',
          );
        }
      } else {
        RLoadersSnackBar.errorSnackBar(
          title: 'User Not Found',
          message: 'No user is currently logged in.',
        );
      }
    } catch (e) {
      RLoadersSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }
  }

  /// Timer to automatically redirect an Email Verification
  void setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final supabase = Supabase.instance.client;
      final session = supabase.auth.currentSession;

      if (session != null) {
        final user = session.user;
        if (user.emailConfirmedAt != null) {
          if (kDebugMode) {
            print('User email verified');
          }
          timer.cancel();
          // Redirect to desired page
          Get.off(() => SuccessScreen(
              image: RImages.successAnimation,
              title: RTexts.yourAccountCreatedTitle,
              subtitle: RTexts.yourAccountCreatedSubtitle,
              onPressed: () =>
                  AuthenticationRepository.instance.screenRedirect()));
        } else {
          if (kDebugMode) {
            print('User email not verified yet.');
          }
        }
            }
    });
  }

  /// Manually check if Email Verified
  checkEmailVerificationStatus() async {
    final session = Supabase.instance.client.auth.currentSession;
    final currentUser = session?.user;
    if (currentUser != null && currentUser.emailConfirmedAt != null) {
      Get.off(() => SuccessScreen(
          image: RImages.successAnimation,
          title: RTexts.yourAccountCreatedTitle,
          subtitle: RTexts.yourAccountCreatedSubtitle,
          onPressed: () => AuthenticationRepository.instance.screenRedirect()));
    } else {
      // Handle cases where the user is null or email is not verified
      if (kDebugMode) {
        print("User is not verified or not logged in.");
      }
    }
  }
}
