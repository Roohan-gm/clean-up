import 'package:clean_up/data/repositories/authentication/authentication_repository.dart';
import 'package:clean_up/utils/constants/image_strings.dart';
import 'package:clean_up/utils/http/network_manager.dart';
import 'package:clean_up/utils/popups/fill_screen_loader.dart';
import 'package:clean_up/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  ///Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? ''; // Default to an empty string
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? ''; // Default to an empty string
    super.onInit();
  }


  Future<void> emailAndPasswordSignIn() async {
    try {
      // Start loading
      RFullScreenLoader.openLoadingDialog(
          'Logging you in...', RImages.lottieAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        RFullScreenLoader.stopLoading();
        return;
      }

      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      // Login user using Email & Password Authentication
      await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Remove Loader
      RFullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      RFullScreenLoader.stopLoading();
      RLoadersSnackBar.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
