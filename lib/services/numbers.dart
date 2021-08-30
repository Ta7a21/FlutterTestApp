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

  static int search(List<int> numbers, String number) {
    int numberToSearch = -2;
    if (int.tryParse(number) == null)
      return numberToSearch;
    else {
      numberToSearch = int.parse(number);
      numbers.sort();
      // ignore: await_only_futures
      return binarySearch(numbers, numberToSearch);
    }
  }
}
