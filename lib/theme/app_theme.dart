import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get twitterTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundGray,
      appBarTheme: AppBarTheme(
        color: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.white),
        titleTextStyle: TextStyles.appBarTitle,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      iconTheme: IconThemeData(color: AppColors.primary),
      textTheme: TextTheme(
        displayLarge: TextStyles.headline1,
        displayMedium: TextStyles.headline2,
        bodyLarge: TextStyles.bodyText1,
        bodyMedium: TextStyles.bodyText2,
        bodySmall: TextStyles.caption,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.primary,
        textTheme: ButtonTextTheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.extraLightGray,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        labelStyle: TextStyle(color: AppColors.darkGray),
      ),
    );
  }
}