extension ListExt on List {
  List<T> removeNulls<T>() {
    return where((element) => element != null).cast<T>().toList();
  }

  List<T> removeDuplicates<T>([Object Function(T)? key]) {
    final Map<Object, T> seen = {};
    for (final item in this) {
      final k = key != null ? key(item) : item;
      seen.putIfAbsent(k, () => item);
    }
    return seen.values.toList();
  }

  List<T> uniqueBy<T>(Object Function(T) key) {
    final Map<Object, T> seen = {};
    for (final item in this) {
      seen.putIfAbsent(key(item), () => item);
    }
    return seen.values.toList();
  }
}
