import 'package:clean_up/features/screens/login/login.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends GetxController {
  // Observables to track user login, onboarding, and selected mode
  var isLoggedIn = false.obs;
  var isOnboardingCompleted = false.obs;
  var lastSelectedMode = 'user'.obs; // 'user' or 'cleaner'
  var isRegistrationComplete = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAppState();
  }

  // Initialize app state by loading data from SharedPreferences
  Future<void> _initializeAppState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
      isOnboardingCompleted.value = prefs.getBool('isOnboardingCompleted') ?? false;
      lastSelectedMode.value = prefs.getString('lastSelectedMode') ?? 'user';
      isRegistrationComplete.value = prefs.getBool('isRegistrationComplete') ?? false;
      _navigateToCorrectScreen();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing app state: $e');
      }
      Get.offAllNamed('/login'); // Fallback to login on error
    }
  }

  // Navigate to the appropriate screen based on app state
  void _navigateToCorrectScreen() {
    if (!isOnboardingCompleted.value) {
      Get.offAllNamed('/onboarding');
    } else if (!isLoggedIn.value) {
      Get.offAllNamed('/login');
    } else {
      _navigateBasedOnMode();
    }
  }

  // Navigate based on the last selected mode
  void _navigateBasedOnMode() {
    if (lastSelectedMode.value == 'user') {
      Get.offAllNamed('/home');
    } else if (lastSelectedMode.value == 'cleaner') {
      if (isRegistrationComplete.value) {
        Get.offAllNamed('/navigationMenu');
      } else {
        Get.offAllNamed('/registration');
      }
    }
  }

  // Save the app state to SharedPreferences
  Future<void> _saveAppState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', isLoggedIn.value);
      await prefs.setBool('isOnboardingCompleted', isOnboardingCompleted.value);
      await prefs.setString('lastSelectedMode', lastSelectedMode.value);
      await prefs.setBool('isRegistrationComplete', isRegistrationComplete.value);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving app state: $e');
      }
    }
  }

  // Login the user and navigate to the default user home screen
  Future<void> login() async {
    isLoggedIn.value = true;
    await _saveAppState();
    Get.offAllNamed('/home');
  }

  // Logout the user and navigate to the login screen
  Future<void> logout() async {
    isLoggedIn.value = false;
    await _saveAppState();
    Get.offAllNamed('/login');
  }

  // Mark onboarding as completed and navigate to the login screen
  Future<void> completeOnboarding() async {
    isOnboardingCompleted.value = true;
    await _saveAppState();
    Get.off(()=>const LoginScreen());
    // Get.offAllNamed('/login');
  }

  // Switch between User and Cleaner mode
  void switchMode(String mode) {
    if (lastSelectedMode.value != mode) {
      lastSelectedMode.value = mode;
      _saveAppState();
    }

    if (mode == 'user') {
      Get.offAllNamed('/home');
    } else if (mode == 'cleaner') {
      if (isRegistrationComplete.value) {
        Get.offAllNamed('/navigationMenu');
      } else {
        Get.offAllNamed('/registration');
      }
    }
  }

  // Complete Cleaner registration and navigate to Cleaner home screen
  Future<void> completeRegistration() async {
    isRegistrationComplete.value = true;
    await _saveAppState();
    Get.offAllNamed('/navigationMenu');
  }
}
