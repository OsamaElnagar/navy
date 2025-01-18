import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/defaults.dart';
import 'app_colors.dart';
import 'widgets/app_text_form_field_theme.dart';

class AppTheme {
  static ThemeData light(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bgLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgLight,
        iconTheme: IconThemeData(color: AppColors.titleLight),
        titleTextStyle: TextStyle(color: AppColors.titleLight),
        actionsIconTheme: IconThemeData(color: AppColors.titleLight),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.bgSecondaryLight,
        surfaceTintColor: AppColors.bgSecondaryLight,
      ),
      primaryColor: AppColors.primary,
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
          .apply(
              bodyColor: AppColors.titleLight,
              displayColor: AppColors.titleLight)
          .copyWith(
            bodyLarge: const TextStyle(color: AppColors.textLight),
            bodyMedium: const TextStyle(color: AppColors.textLight),
            bodySmall: const TextStyle(color: AppColors.textLight),
          ),
      dialogBackgroundColor: AppColors.bgSecondaryLight,
      menuButtonTheme: MenuButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            WidgetStateColor.resolveWith(
              (states) => AppColors.bgLight,
            ),
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.iconLight),
      cardTheme: CardTheme(
        color: AppColors.bgSecondaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDefaults.borderRadius),
        ),
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: AppColors.highlightLight,
        selectedColor: AppColors.primary,
      ),
      dividerColor: AppColors.highlightLight,
      dividerTheme: const DividerThemeData(
        thickness: 1,
        color: AppColors.highlightLight,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(100, 56),
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppDefaults.borderRadius),
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.titleLight,
          minimumSize: const Size(100, 56),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDefaults.padding,
            vertical: AppDefaults.padding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDefaults.borderRadius),
          ),
          side: const BorderSide(
            color: AppColors.highlightLight,
            width: 2,
          ),
        ),
      ),
      inputDecorationTheme: AppTextFormFieldTheme.lightInputDecorationTheme,
      expansionTileTheme: const ExpansionTileThemeData(
        shape: RoundedRectangleBorder(),
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: AppColors.error,
        smallSize: 8,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDefaults.borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDefaults.borderRadius),
            borderSide:
                const BorderSide(width: 2, color: AppColors.highlightLight),
          ),
        ),
      ),
    );
  }

  static ThemeData dark(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bgDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgDark,
        iconTheme: IconThemeData(color: AppColors.titleDark),
        titleTextStyle: TextStyle(color: AppColors.titleDark),
        actionsIconTheme: IconThemeData(color: AppColors.titleDark),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.bgSecondaryDark,
        surfaceTintColor: AppColors.bgSecondaryDark,
      ),
      buttonTheme: const ButtonThemeData(),
      primaryColor: AppColors.primary,
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
          .apply(
              bodyColor: AppColors.titleDark, displayColor: AppColors.titleDark)
          .copyWith(
            bodyLarge: const TextStyle(color: AppColors.textDark),
            bodyMedium: const TextStyle(color: AppColors.textDark),
            bodySmall: const TextStyle(color: AppColors.textDark),
          ),
      menuButtonTheme: MenuButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            WidgetStateColor.resolveWith(
              (states) => AppColors.bgDark,
            ),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.bgSecondaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDefaults.borderRadius),
        ),
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: AppColors.highlightLight,
        selectedColor: AppColors.primary,
      ),
      iconTheme: const IconThemeData(color: AppColors.iconDark),
      dividerColor: AppColors.highlightDark,
      dividerTheme: const DividerThemeData(
        thickness: 1,
        color: AppColors.highlightDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(100, 56),
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: AppColors.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppDefaults.borderRadius),
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.titleDark,
          minimumSize: const Size(100, 56),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDefaults.padding,
            vertical: AppDefaults.padding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDefaults.borderRadius),
          ),
          side: const BorderSide(
            color: AppColors.highlightDark,
            width: 2,
          ),
        ),
      ),
      inputDecorationTheme: AppTextFormFieldTheme.darkInputDecorationTheme,
      expansionTileTheme: const ExpansionTileThemeData(
        shape: RoundedRectangleBorder(),
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: AppColors.error,
        smallSize: 8,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(Colors.black),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDefaults.borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDefaults.borderRadius),
            borderSide:
                const BorderSide(width: 2, color: AppColors.highlightDark),
          ),
        ),
      ),
    );
  }
}
