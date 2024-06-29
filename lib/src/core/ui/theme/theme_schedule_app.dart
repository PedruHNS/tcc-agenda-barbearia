import 'package:barbershop_schedule/src/core/constants/constants.dart';
import 'package:flutter/material.dart';

sealed class ThemeScheduleApp {
  static const _defaultBorderOutline = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
    borderSide: BorderSide(color: Colors.grey),
  );

  static const _defaultBorderRoundedRectangle = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
    Radius.circular(8),
  ));

  static ThemeData themeDefault = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: ColorsConstants.primary),
    datePickerTheme: const DatePickerThemeData(
      shape: _defaultBorderOutline,
     
    ),

    //! app bar finalizada o tema
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      iconTheme: IconThemeData(color: ColorsConstants.primary),
      backgroundColor: Colors.white,
      foregroundColor: ColorsConstants.primary,
    ),
    //! app bar finalizada o tema

    //! input finalizado o tema
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: ColorsConstants.grey),
      hintStyle: const TextStyle(color: ColorsConstants.grey),
      border: _defaultBorderOutline,
      enabledBorder: _defaultBorderOutline,
      focusedBorder: _defaultBorderOutline,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      errorBorder: _defaultBorderOutline.copyWith(
          borderSide: const BorderSide(color: ColorsConstants.error)),
    ),
    //! input finalizado o tema
    cardTheme: const CardTheme(shape: _defaultBorderRoundedRectangle),

    //! outline finalizado tema
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
        foregroundColor: ColorsConstants.primary,
        side: const BorderSide(color: ColorsConstants.primary, width: 1),
        shape: _defaultBorderRoundedRectangle,
      ),
    ),
    //! outline finalizado tema

    //!elevatedButton finalizado o tema
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsConstants.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: _defaultBorderRoundedRectangle,
      ),
    ),
    //!elevatedButton finalizado o tema

    fontFamily: FontConstants.fontfamily,
    textTheme: const TextTheme(
      displayMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      displayLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
