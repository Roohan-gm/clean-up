import 'package:clean_up/features/screens/home/home.dart';
import 'package:clean_up/features/screens/login/login.dart';
import 'package:clean_up/features/screens/onboarding/onboarding.dart';
import 'package:clean_up/features/screens/signup/verify_email.dart';
import 'package:clean_up/supabase_user_credential.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../navigation_menu.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// Variables
  final deviceStorage = GetStorage();
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get authUser => _supabase.auth.currentUser;

  /// called from main.dart on app launch
  @override
  void onReady() {
    // Remove the native splash screen
    FlutterNativeSplash.remove();
    // Redirect to the appropriate screen
    screenRedirect();
  }

  /// Function to Show Relevant Screen
  screenRedirect() async {
    final user = _supabase.auth.currentSession?.user;
    if (user != null) {
      if (user.emailConfirmedAt != null) {
        // Fetch user role from the profiles table
        final response = await _supabase
            .from('Users')
            .select('role')
            .eq('id', user.id)
            .maybeSingle();

        if (response == null || response.isEmpty) {
          if (kDebugMode) {
            print('User does not exist in the database. Logging out.');
          }
          await _supabase.auth.signOut();
          Get.offAll(() => const LoginScreen());
          return;
        }

        // Get.offAll(() => const HomeScreen());
        String role = response['role'];
        if (role == 'cleaner') {
          Get.offAll(
              () => const NavigationMenu()); // Navigate to Cleaner Screen
        } else {
          Get.offAll(() =>
              const HomeScreen()); // Navigate to Home Screen for customers
        }
      } else {
        Get.offAll(() => VerifyEmailScreen(email: user.email));
      }
    } else {
      if (kDebugMode) {
        print(deviceStorage.read('isFirstTime'));
      }
      // local storage
      deviceStorage.writeIfNull('isFirstTime', true);
      // Check if it's the first tme launching the app
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(const OnBoardingScreen());
    }
  }

  /* ------------------------------ Email & Password sign_in -------------------- */

  ///[EmailAuthentication] - LOGIN
  Future<String?> fetchUserRoleFromDatabase(User user) async {
    try {
      final response = await _supabase
          .from('Users')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();
      if (response == null) {
        throw Exception('User role not found in the database.');
      }
      final role = response['role'];
      if (role == null) {
        throw Exception('User role not found in the database.');
      }
      return role;
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching user role: $error');
      }
      return null;
    }
  }

  Future<SupabaseUserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      // Attempt to sign in
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      final session = response.session;

      if (user != null) {
        if (kDebugMode) {
          print('User Signed in successfully: ${user.email}');
        }
        debugPrint('User ID after login: ${user.id}');
        // Fetch user role from the profiles table
        final String? role = await fetchUserRoleFromDatabase(user);
        if (role == null) {
          throw Exception('User role not found in the database.');
        }

        // Redirect based on role
        if (role == 'cleaner') {
          Get.offAll(() => const NavigationMenu());
        } else {
          Get.offAll(() => const HomeScreen());
        }

        // Return the custom SupabaseUserCredential with user and session data
        return SupabaseUserCredential(user: user, session: session);
      } else {
        throw 'Sign-in failed. No user found.';
      }
    } on AuthException catch (e) {
      if (kDebugMode) {
        print('Authentication Error: ${e.message}');
      }
      throw e
          .message; // Re-throwing the error for the calling function to handle
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Error: $e');
      }
      throw 'Something went wrong. Please try again.';
    }
  }

  ///[EmailAuthentication] - REGISTER
  Future<SupabaseUserCredential> registerUserWithEmailAndPassword(
      String email, String password) async {
    try {
      // Attempt to register user
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      final session = response.session;

      // Check if the user was successfully created
      if (user == null) {
        throw 'Registration failed: User object is null';
      }

      if (kDebugMode) {
        print('User registered successfully: ${user.email}');
      }

      // Return the custom SupabaseUserCredential object
      return SupabaseUserCredential(user: user, session: session);
    } on AuthException catch (e) {
      // Handle Supabase-specific authentication errors
      debugPrint('Authentication Error: ${e.message}');
      throw 'Authentication Error: ${e.message}';
    } on PlatformException catch (e) {
      // Handle platform-specific issues
      debugPrint('Platform Error: ${e.message}');
      throw 'Platform Error: ${e.message}';
    } catch (e) {
      // Catch any other exceptions
      debugPrint('General Error: $e');
      throw 'Something went wrong. Please try again.';
    }
  }

  ///[EmailAuthentication] - FORGET PASSWORD
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email.trim());
    } on AuthException catch (e) {
      // Throw Supabase-specific authentication errors
      throw Exception('Authentication Error: ${e.message}');
    } on PlatformException catch (e) {
      // Throw platform-specific errors
      throw Exception('Platform Error: ${e.message}');
    } catch (e) {
      // Throw any other exceptions
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  ///[LogoutUser] - Valid for any authentication
  Future<void> logout() async {
    try {
      // Attempt to sign out the user
      await _supabase.auth.signOut();

      // Redirect to the Login Screen
      Get.offAll(() => const LoginScreen());
    } on AuthException catch (e) {
      // Throw Supabase-specific authentication errors
      throw Exception('Authentication Error: ${e.message}');
    } on PlatformException catch (e) {
      // Throw platform-specific errors
      throw Exception('Platform Error: ${e.message}');
    } catch (e) {
      // Throw any other exceptions
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}
