import 'package:flutter/material.dart';

enum EVideoStatus {
  notChecked("NOT_CHECKED"),
  private("PRIVATE"),
  inQueue("IN_QUEUE"),
  notReady("NOT_READY"),
  active("ACTIVE"),
  storage("STORAGE"),
  ;

  final String value;

  const EVideoStatus(this.value);

  static EVideoStatus? enumOf(String? json) {
    for (final type in EVideoStatus.values) {
      if (type.value == json) {
        return type;
      }
    }
    return null;
  }

  String get title {
    switch (this) {
      case EVideoStatus.notChecked:
        return "Not checked";
      case EVideoStatus.private:
        return "Private";
      case EVideoStatus.inQueue:
        return "In queue";
      case EVideoStatus.notReady:
        return "Not ready";
      case EVideoStatus.active:
        return "Active";
      case EVideoStatus.storage:
        return "Storage";
    }
  }

  Color get color {
    switch (this) {
      case EVideoStatus.notChecked:
        return Colors.grey.shade700;
      case EVideoStatus.private:
        return Colors.red.shade700;
      case EVideoStatus.inQueue:
        return Colors.blue.shade700;
      case EVideoStatus.notReady:
        return Colors.red.shade700;
      case EVideoStatus.active:
        return Colors.green.shade700;
      case EVideoStatus.storage:
        return Colors.red.shade700;
    }
  }
}
