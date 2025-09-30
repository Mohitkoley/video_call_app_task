extension StrigExt on String {
  String get capitalize => "${this[0].toUpperCase()}${substring(1)}";

  int get toInt => int.tryParse(this) ?? 0;

  String get maskEmail =>
      "${substring(0, 3)}****@${split('@')[1].substring(0, 3)}****";
}
