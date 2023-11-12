enum EOrientation {
  landscape("LANDSCAPE"),
  portrait("PORTRAIT"),
  ;

  final String value;

  const EOrientation(this.value);

  static EOrientation? enumOf(String? json) {
    for (final type in EOrientation.values) {
      if (type.value == json) {
        return type;
      }
    }
    return null;
  }
}