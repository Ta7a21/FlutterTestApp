import 'package:flutter/foundation.dart';
import 'dart:math';

class Numbers {
  static List<int> generateNumbers() {
    List<int> numbers = [];
    var rng = new Random();
    for (var i = 0; i < 10000; i++) {
      numbers.add(rng.nextInt(10000));
    }
    return numbers;
  }

  static int search(List<int> numbers, int numberToSearch) {
    numbers.sort();
    // ignore: await_only_futures
    // Returns -1 if not found, else it returns the number's index
    return binarySearch(numbers, numberToSearch);
  }
}
