import 'package:flutter/material.dart';

extension TextStyleExt on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  TextStyle get normal => copyWith(fontWeight: FontWeight.normal);

  TextStyle get grey => copyWith(color: Colors.grey);
}
