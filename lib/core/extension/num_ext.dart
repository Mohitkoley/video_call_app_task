import 'package:flutter/material.dart';

extension NumExt on num {
  SizedBox get hBox => SizedBox(height: toDouble());
  SizedBox get wBox => SizedBox(width: toDouble());
  SizedBox get hwBox => SizedBox(width: toDouble(), height: toDouble());

  String get twoDigits => toString().padLeft(2, "0");
}
