import 'package:flutter/material.dart';
import '../../core/theme/app_pallete.dart';

class Apptheme {
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.primaryColor,
  );
  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.primaryColor,
  );
}
