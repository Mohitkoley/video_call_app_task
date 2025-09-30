import 'package:flutter/material.dart';
import 'package:video_calling/core/theme/color_pallette.dart';
import 'package:video_calling/core/utils/widget_state_util.dart';

class CommonButton {
  //variables and constraints
  EdgeInsetsGeometry commonPadding = const EdgeInsets.all(30.0);

  static const double elevatedButtonHeight = 50;
  static const Size elevatedButtonSize = Size(
    double.infinity,
    elevatedButtonHeight,
  );

  //methods
  static ElevatedButton buildElevatedButton({
    required VoidCallback onPressed,
    required String text,
    TextStyle style = const TextStyle(
      fontSize: 20,
      color: ColorPalette.whiteColor,
    ),
    bool isValid = true,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(elevatedButtonSize),
        backgroundColor: isValid
            ? WidgetStateUtil.colorProperty(ColorPalette.primaryColor)
            : WidgetStateUtil.colorProperty(ColorPalette.disabledPrimaryColor),
        fixedSize: WidgetStateProperty.all(elevatedButtonSize),
      ),
      child: Text(text, style: style),
    );
  }

  //  static ElevatedButton buildDiffColoredElevatedButton({
  //   required VoidCallback onPressed,
  //   required String text,
  //   TextStyle style = const TextStyle(
  //     fontSize: 20,
  //     color: ColorPalette.whiteColor,
  //   ),
  //   bool isValid = true,
  //   Color buttonColor = ColorPalette.buttonEnabledColor,
  //   Color buttonDisabledColor = ColorPalette.buttonDisabledColor,
  // }) {
  //   return ElevatedButton(
  //     onPressed: onPressed,
  //     style: ButtonStyle(
  //       backgroundColor: isValid
  //           ? Utils.colorProperty(buttonColor)
  //           : Utils.colorProperty(buttonDisabledColor),
  //       fixedSize: WidgetStateProperty.all(
  //         CommonConstraints.elevatedButtonSize,
  //       ),
  //     ),
  //     child: Text(
  //       text,
  //       style: style,
  //     ),
  //   );
  // }
}
