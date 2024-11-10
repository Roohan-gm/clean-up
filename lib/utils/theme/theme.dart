
import 'package:flutter/material.dart';

import 'custom_theme/appbar_theme.dart';
import 'custom_theme/bottom_sheet_theme.dart';
import 'custom_theme/checkbox_theme.dart';
import 'custom_theme/chip_theme.dart';
import 'custom_theme/elevated_button_theme.dart';
import 'custom_theme/outlined_button_theme.dart';
import 'custom_theme/text_field_theme.dart';
import 'custom_theme/text_theme.dart';

class RAppTheme {
  RAppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      textTheme: RTextTheme.lightTextTheme,
      elevatedButtonTheme: RElevatedButtonTheme.lightElevatedButtonTheme,
      appBarTheme: RAppBarTheme.lightAppBarTheme,
      bottomSheetTheme: RBottomSheetTheme.lightBottomSheetTheme,
      checkboxTheme: RCheckboxTheme.lightCheckboxTheme,
      chipTheme: RChipThemeData.lightChipTheme,
      outlinedButtonTheme: ROutlinedButtonTheme.lightOutlinedButtonTheme,
      inputDecorationTheme: RTextFormfieldTheme.lightInputDecorationTheme);
  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.black12,
      textTheme: RTextTheme.darkTextTheme,
      elevatedButtonTheme: RElevatedButtonTheme.darkElevatedButtonTheme,
      appBarTheme: RAppBarTheme.darkAppBarTheme,
      bottomSheetTheme: RBottomSheetTheme.darkBottomSheetTheme,
      checkboxTheme: RCheckboxTheme.darkCheckboxTheme,
      chipTheme: RChipThemeData.darkChipTheme,
      outlinedButtonTheme: ROutlinedButtonTheme.darkOutlinedButtonTheme,
      inputDecorationTheme: RTextFormfieldTheme.darkInputDecorationTheme);
}
