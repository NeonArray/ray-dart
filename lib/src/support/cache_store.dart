import 'package:meta/meta.dart';

class CacheStore {
  @protected
  List<DateTime> store = [];

  CacheStore();

  void hit() {
    store.add(DateTime.now());
  }

  void clear() {
    store = [];
  }

  int count() {
    return store.length;
  }

  int countLastSecond() {
    var amount = 0;
    var lastSecond = DateTime.now().subtract(Duration(seconds: 1));

    for (var item in store) {
      if (isBetween(
        item.millisecondsSinceEpoch ~/ 1000,
        lastSecond.millisecondsSinceEpoch ~/ 1000,
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
      )) {
        amount++;
      }
    }

    return amount;
  }

  @protected
  bool isBetween(int toCheck, int start, int end) {
    return toCheck >= start && toCheck <= end;
  }
}
