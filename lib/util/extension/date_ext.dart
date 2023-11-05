import 'package:intl/intl.dart';

extension DateExt on DateTime {
  String format(String pattern) {
    final formatter = DateFormat(pattern);
    return formatter.format(this);
  }
}