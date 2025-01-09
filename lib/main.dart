import 'dart:async';
import 'package:clean_up/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';

Future<void> main() async {
  /// Widgets Binding ensures that the Flutter framework is initialized properly
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  debugPrint("Widgets Binding initialized.");
  await dotenv.load(fileName: ".env");

  try {
    // Initialize GetX Local Storage (GetStorage)
    await GetStorage.init();
    debugPrint("GetStorage initialized.");

    // Preserve the splash screen until all initialization is complete
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    debugPrint("Splash screen preserved.");

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase initialized.");

    // Initialize SharedPreferences
    await SharedPreferences.getInstance();
    debugPrint("SharedPreferences initialized.");

    // Initialize Supabase
    await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        anonKey: dotenv.env['SUPABASE_ANON_KEY']!);
    debugPrint("Supabase initialized.");

    // Inject the AuthenticationRepository into GetX dependency management
    Get.put(AuthenticationRepository());
    debugPrint("AuthenticationRepository initialized.");


    // Run the app
    runApp(const App());
    debugPrint("App launched successfully.");
  } catch (e) {
    // Catch and log any errors during initialization
    debugPrint('Error initializing services: $e');
  }
}
