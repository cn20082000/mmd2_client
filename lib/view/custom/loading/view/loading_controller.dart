class LoadingController {
  bool _loading = false;

  final List<void Function()?> _listeners = [];

  void invokeListeners() {
    for (final element in _listeners) {
      element?.call();
    }
  }

  void clearListener() => _listeners.clear();

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    invokeListeners();
  }

  set listener(void Function()? value) => _listeners.add(value);
}
