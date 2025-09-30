import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;

  void showSnack(String msg, {Color color = Colors.black}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
    ));
  }

  // keyboard height
  double get keyBoardHeightPadding => MediaQuery.of(this).viewInsets.bottom;

  //theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;

  TextStyle get bodyLarge => textTheme.bodyLarge!;
  TextStyle get bodyMedium => textTheme.bodyMedium!;
  TextStyle get bodySmall => textTheme.bodySmall!;

  bool get isKeyBoardOpened => keyBoardHeightPadding > 0;
}
