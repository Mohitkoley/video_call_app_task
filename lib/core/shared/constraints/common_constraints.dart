import 'package:flutter/material.dart';

class CommonConstraints {
  // PrefixConstraints
  static const double textFieldIconMaxHeight = 40;
  static const double textFieldIconMaxWidth = 40;
  static const double textFieldIconMinWidth = 40;
  static const double textFieldIconMinHeight = 40;
  // TextField
  static const double textFieldMaxHeight = 80;
  static const double textFieldMinHeight = 50;

  // PrefixConstraints
  static const BoxConstraints textFieldPrefixConstraints = BoxConstraints(
    maxHeight: textFieldIconMaxHeight,
    maxWidth: textFieldIconMaxWidth,
    minWidth: textFieldIconMinWidth,
    minHeight: textFieldIconMinHeight,
  );

  //suffixConstraints
  static const textFieldSuffixConstraints = BoxConstraints(
    maxHeight: textFieldIconMaxHeight,
    maxWidth: textFieldIconMaxWidth,
    minWidth: textFieldIconMinWidth,
    minHeight: textFieldIconMinHeight,
  );

  static const BoxConstraints textFieldBoxConstraints = BoxConstraints(
      minHeight: textFieldMinHeight, maxHeight: textFieldMaxHeight);

  static const BoxConstraints textFieldIconBoxConstraints = BoxConstraints(
    maxHeight: textFieldIconMaxHeight,
    maxWidth: textFieldIconMaxWidth,
    minWidth: textFieldIconMinWidth,
    minHeight: textFieldIconMinHeight,
  );

  static const BoxConstraints textFieldBoxConstraintsMaxHeight =
      BoxConstraints(maxHeight: textFieldMaxHeight);
}
