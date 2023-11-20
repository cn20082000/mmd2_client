import 'package:flutter/widgets.dart';

class LoadingController {
  bool _loading = false;

  final List<void Function()?> _listeners = [];

  @protected
  void invokeListeners() {
    for (final element in _listeners) {
      element?.call();
    }
  }

  void removeListener(void Function() value) => _listeners.remove(value);

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    invokeListeners();
  }

  set listener(void Function()? value) => _listeners.add(value);
}
