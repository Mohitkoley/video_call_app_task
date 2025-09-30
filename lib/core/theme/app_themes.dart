import 'package:flutter/material.dart';
import 'package:video_calling/core/theme/color_pallette.dart';
import 'package:video_calling/core/utils/widget_state_util.dart';

class AppThemes {
  static double get borderRadius => 30;
  static double get textFieldBorderRadius => 10;
  static double get largefontSize => 22;
  static double get mediumfontSize => 18;
  static double get smallfontSize => 11;
  static FontWeight get fontBold => FontWeight.bold;
  static const double iconSize = 30;

  //button
  static OutlineInputBorder _border([
    Color color = ColorPalette.textFieldBorderColor,
  ]) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 1),
    borderRadius: BorderRadius.circular(textFieldBorderRadius),
  );

  static InputDecorationTheme inputDecorationTheme() {
    return InputDecorationTheme(
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(),
      errorBorder: _border(Colors.red),
      focusedErrorBorder: _border(Colors.red),
      disabledBorder: _border(Colors.grey),
      hintStyle: bodySmall.copyWith(color: ColorPalette.hintTextColor),
      errorStyle: bodySmall.copyWith(
        color: ColorPalette.redColor,
        fontSize: 12,
      ),
    );
  }

  //styles
  static TextStyle get bodyLarge =>
      TextStyle(fontSize: largefontSize, color: ColorPalette.blackColor);

  static TextStyle get bodyMedium =>
      TextStyle(fontSize: mediumfontSize, color: ColorPalette.blackColor);

  static TextStyle get bodySmall =>
      TextStyle(fontSize: smallfontSize, color: ColorPalette.blackColor);

  // common text theme
  static TextTheme commonTextTheme({Color color = ColorPalette.blackColor}) {
    return TextTheme(
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
    );
  }

  static IconThemeData iconTheme({double iconsSize = iconSize}) {
    return const IconThemeData(
      size: iconSize,
      color: ColorPalette.blackColor,
      weight: 300,
    );
  }

  static AppBarTheme appBarTheme() {
    return AppBarTheme(
      backgroundColor: ColorPalette.whiteColor,
      elevation: 10,
      surfaceTintColor: Colors.white,
      iconTheme: iconTheme(iconsSize: 18),
      titleTextStyle: bodyMedium,
    );
  }

  // elevated button theme
  static ElevatedButtonThemeData get elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateUtil.colorProperty(
            ColorPalette.primaryColor,
          ),
          shape: WidgetStateUtil.shapeProperty(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          minimumSize: WidgetStateUtil.widgetSizedProperty(),
        ),
      );

  static ThemeData lightThemeData = ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: ColorPalette.primaryColor),
    textTheme: commonTextTheme(),
    elevatedButtonTheme: elevatedButtonTheme,
    scaffoldBackgroundColor: ColorPalette.whiteColor,
    inputDecorationTheme: inputDecorationTheme(),
    appBarTheme: appBarTheme(),
    iconTheme: iconTheme(),
    dividerColor: ColorPalette.primaryColor,
  );
}
