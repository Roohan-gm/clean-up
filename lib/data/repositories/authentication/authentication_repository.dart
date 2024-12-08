import 'package:clean_up/features/screens/login/login.dart';
import 'package:clean_up/features/screens/onboarding/onboarding.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// Variables
  final deviceStorage = GetStorage();
  final SupabaseClient _supabase = Supabase.instance.client;


  /// called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  /// Function to Show Relevant Screen
  screenRedirect() async {
    // local storage
    if (kDebugMode) {
      print(deviceStorage.read('isFirstTime'));
    }
    deviceStorage.writeIfNull('isFirstTime', true);
    deviceStorage.read('isFirstTime') != true
        ? Get.offAll(() => const LoginScreen())
        : Get.offAll(() => const OnBoardingScreen());
  }

  /* ------------------------------ Email & Password sign_in -------------------- */

  ///[EmailAuthentication] - SignIn

  ///[EmailAuthentication] - REGISTER
  Future<String> registerUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final response =
          await _supabase.auth.signUp(password: password, email: email);
       final userId = response.user?.id;

      // check if user was successfully created
      if (userId == null) {
        throw 'Registration failed:User object is null';
      }

      // If you need to handel additional user setup after registration,
      if (kDebugMode) {
        print('User registered successfully: ${response.user?.email}');
      }
      return userId;
    } on AuthException catch (e) {
      // Handel Supabase-specific authentication errors
      throw 'Authentication Error: ${e.message}';
    } on PlatformException catch (e) {
      // Handle platform-specific issues
      throw 'Platform Error: ${e.message}';
    } catch (e) {
      //Catch any other exceptions
      throw 'Something went wrong. Please try again.';
    }
  }

// Future<UserCredential> registerUserWithEmailAndPassword(String email, String password) async{
//   try{
//     return await _auth.createUserWithEmailAndPassword(String email, String password);
//   } on FirebaseAuthException catch (e){
//     throw RFirebaseAuthException(e.code).message;
//   }on FirebaseException catch (e) {
//     throw RFirebaseException(e.code).message;
//   }on FormatException catch (e) {
//     throw const RFormatException();
//   }on PlatformException catch (e) {
//     throw RPlatformException(e.code).message;
//   }catch(e){
//     throw 'Something went wrong. please try again';
//   }
// }
}
