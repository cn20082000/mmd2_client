extension StringOptionalExt on String? {
  String nullOrEmpty(String defaultValue) {
    if (this == null || this?.isEmpty == true) {
      return defaultValue;
    }
    return this!;
  }
}