import 'package:clean_up/features/screens/home/home.dart';
import 'package:clean_up/features/screens/login/login.dart';
import 'package:clean_up/features/screens/onboarding/onboarding.dart';
import 'package:clean_up/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/screens/register_screen/register_screen.dart';
import 'navigation_menu.dart';

enum AppMode { user, cleaner }

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: RAppTheme.lightTheme,
      darkTheme: RAppTheme.darkTheme,
      getPages: [
        GetPage(name: '/onboarding', page: () => const OnBoardingScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/registration', page: () => const RegisterScreen()),
        GetPage(name: '/navigationMenu', page: () => const NavigationMenu()),
      ],
      home: const NavigationMenu(),
    );
  }
}
