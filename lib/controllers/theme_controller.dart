// import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/core/helpers/log_helper.dart';
import 'package:navy/utils/app_constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  ThemeController({required this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    if (mode != ThemeMode.system) {
      sharedPreferences.setString(AppConstants.theme, mode.toString());
    } else {
      sharedPreferences.remove(AppConstants.theme);
    }
    printLog('Theme mode changed to: ${mode.toString()}');
    update();
  }

  void _loadCurrentTheme() {
    try {
      // Try to read new string format first
      String? savedTheme = sharedPreferences.getString(AppConstants.theme);
      if (savedTheme != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (e) => e.toString() == savedTheme,
          orElse: () => ThemeMode.system,
        );
      } else {
        // Check for old boolean format and migrate
        bool? oldTheme = sharedPreferences.getBool(AppConstants.theme);
        if (oldTheme != null) {
          // Migrate old boolean preference to new enum format
          _themeMode = oldTheme ? ThemeMode.dark : ThemeMode.light;
          // Save in new format
          setThemeMode(_themeMode);
        } else {
          _themeMode = ThemeMode.system;
        }
      }
    } catch (e) {
      // If anything goes wrong, reset to system
      _themeMode = ThemeMode.system;
      sharedPreferences.remove(AppConstants.theme);
    }
    printLog('Current theme loaded: ${_themeMode.toString()}');
    update();
  }
}
