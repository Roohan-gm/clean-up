import 'package:clean_up/data/repositories/authentication/authentication_repository.dart';
import 'package:clean_up/data/repositories/user/user_repositories.dart';
import 'package:clean_up/features/models/user_model.dart';
import 'package:clean_up/features/screens/signup/verify_email.dart';
import 'package:clean_up/utils/popups/fill_screen_loader.dart';
import 'package:clean_up/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/http/network_manager.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  /// variables
  final hidePassword = true.obs; // Observable for hiding/showing password
  final privacyPolicy = true.obs; // Observable for Privacy Policy
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> signupFormKey =
      GlobalKey<FormState>(); // Form key for validation

  /// -- SIGNUP
  Future<void> signup() async {
    try {
      // start loading
      RFullScreenLoader.openLoadingDialog(
          'We are processing your information...', RImages.lottieAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // Remove Loader
        RFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!signupFormKey.currentState!.validate()) {
        print("Signup Form Key: ${signupFormKey.currentState!.validate()}");
        // Remove Loader
        RFullScreenLoader.stopLoading();
        return;
      }

      // Privacy Policy Check
      if (!privacyPolicy.value) {
        RLoadersSnackBar.warningSnackBar(
            title: "Accept Privacy Policy",
            message:
                "Please accept the Privacy Policy & Terms of use.");
        // Remove Loader
        RFullScreenLoader.stopLoading();
        return;
      }

      // Register user in the Supabase Authentication & Save user data in the Supabase
      final userId = await AuthenticationRepository.instance
          .registerUserWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      if (kDebugMode) {
        print(userId);
      }
      // Save Authenticated user data in Supabase Store
      final newUser = UserModel(
          id: userId,
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          email: email.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          username: userName.text.trim(),
          profilePicture: '');

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // Remove Loader
      RFullScreenLoader.stopLoading();

      // Show Success Message
      RLoadersSnackBar.successSnackBar(
          title: 'Congratulations!',
          message: 'Your account has been created!');

      // Move to Verify Email Screen
      Get.to(() => const VerifyEmailScreen());
    } catch (e) {
      // Remove Loader
      RFullScreenLoader.stopLoading();

      RLoadersSnackBar.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }
}
