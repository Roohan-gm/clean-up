import 'package:clean_up/data/repositories/user/user_repositories.dart';
import 'package:clean_up/features/models/user_model.dart';
import 'package:clean_up/features/screens/login/login.dart';
import 'package:clean_up/utils/popups/fill_screen_loader.dart';
import 'package:clean_up/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      _showLoader();
      if (!(await _isConnected())) return;

      if (!_validateForm()) return;

      if (!privacyPolicy.value) {
        _showPrivacyPolicyWarning();
        return;
      }

      final user = await _registerUser();
      if (user == null || user.id.isEmpty) {
        throw Exception("User registration failed, no user ID received.");
      }

      debugPrint('User ID after registration: ${user.id}');

      await _saveUserRecord(user);

      _handleSuccess();
    } catch (e) {
      _handleError(e);
    } finally {
      RFullScreenLoader.stopLoading();
    }
  }

  void _showLoader() {
    RFullScreenLoader.openLoadingDialog(
        'We are processing your information...', RImages.lottieAnimation);
    debugPrint('Loader started');
  }

  Future<bool> _isConnected() async {
    final isConnected = await NetworkManager.instance.isConnected();
    debugPrint('Internet connectivity check result: $isConnected');
    if (!isConnected) {
      debugPrint('No internet connection');
      RFullScreenLoader.stopLoading();
    }
    return isConnected;
  }

  bool _validateForm() {
    if (!signupFormKey.currentState!.validate()) {
      debugPrint('Form validation failed');
      RFullScreenLoader.stopLoading();
      return false;
    }
    debugPrint('Form validation passed');
    return true;
  }

  void _showPrivacyPolicyWarning() {
    debugPrint('Privacy policy not accepted');
    RLoadersSnackBar.warningSnackBar(
        title: "Accept Privacy Policy",
        message: "Please accept the Privacy Policy & Terms of use.");
    RFullScreenLoader.stopLoading();
  }

  Future<User?> _registerUser() async {
    debugPrint('Attempting to register user in Supabase...');
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      final user = response.user;
      if (user == null) {
        throw Exception('User registration failed: No user data returned.');
      }

      debugPrint('User ID: ${user.id}');
      debugPrint('User Email: ${user.email}');

      return user;
    } catch (e, stacktrace) {
      debugPrint('Registration Error: $e');
      debugPrint('Stacktrace: $stacktrace');
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> _saveUserRecord(User user) async {
    debugPrint('Attempting to save user record in Supabase...');
    debugPrint('User ID after registration: ${user.id}');
    final newUser = UserModel(
      id: user.id,
      firstName: firstName.text.trim(),
      lastName: lastName.text.trim(),
      email: email.text.trim(),
      phoneNumber: phoneNumber.text.trim(),
      username: userName.text.trim(),
      profilePicture: '',
    );
    final userRepository = Get.put(UserRepository());
    await userRepository.saveUserRecord(newUser);
    debugPrint('User record saved in Supabase');
  }

  Future<void> _handleSuccess() async {
    debugPrint('Loader stopped');
    RLoadersSnackBar.successSnackBar(
        title: 'Congratulations!', message: 'Your account has been created!');
    debugPrint('Success message displayed');
    await Future.delayed(const Duration(seconds: 3)); // Adjust the delay based on Snackbar duration
    // Debug print before navigation
    debugPrint('Navigating to Login Screen');
    Get.offAll(() => const LoginScreen());
    debugPrint('Navigation executed');
  }

  void _handleError(Object e) {
    debugPrint('Error: $e');
    RLoadersSnackBar.errorSnackBar(title: "Oh Snap!", message: e.toString());
  }
}
