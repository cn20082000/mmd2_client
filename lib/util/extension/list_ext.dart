extension ListExt<E> on List<E> {
  List<R> compactMap<R>(R? Function(E e) block) {
    final result = <R>[];
    for (final e in this) {
      final r = block(e);
      if (r != null) {
        result.add(r);
      }
    }
    return result;
  }
}