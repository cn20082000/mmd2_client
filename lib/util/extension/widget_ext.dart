import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  void showAsDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => this);
  }
}