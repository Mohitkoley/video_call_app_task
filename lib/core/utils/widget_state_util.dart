import 'package:flutter/material.dart';
import 'package:video_calling/core/shared/widgets/button/common_button.dart';

class WidgetStateUtil {
  static WidgetStateProperty<Color> colorProperty<Color>(Color value) =>
      WidgetStatePropertyAll<Color>(value);

  static WidgetStateProperty<Size> widgetSizedProperty({
    Size size = CommonButton.elevatedButtonSize,
  }) => WidgetStatePropertyAll<Size>(size);

  static WidgetStateProperty<OutlinedBorder> shapeProperty({
    BorderRadius borderRadius = BorderRadius.zero,
  }) => WidgetStatePropertyAll<OutlinedBorder>(
    RoundedRectangleBorder(borderRadius: borderRadius, side: BorderSide.none),
  );
}
