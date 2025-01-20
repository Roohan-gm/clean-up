import 'package:clean_up/bindings/general_bindings.dart';
import 'package:clean_up/utils/constants/colors.dart';
import 'package:clean_up/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      initialBinding: GeneralBindings(),
      home: const Scaffold(backgroundColor: RColors.primary,body: Center(child: CircularProgressIndicator(color: RColors.white,),),),
    );
  }
}
