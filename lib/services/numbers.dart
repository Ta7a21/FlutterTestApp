import 'dart:math';

import 'package:flutter/foundation.dart';

class Numbers {
  List<int> list = [];

  void generate() {
    var rng = new Random();
    for (var i = 0; i < 10000; i++) {
      list.add(rng.nextInt(10000));
    }
  }

  int search(int numberToSearch) {
    list.sort(); // O(n log(n))
    // ignore: await_only_futures
    // Returns -1 if not found, else it returns the number's index
    return binarySearch(list, numberToSearch); // O(log n)
  }
}
