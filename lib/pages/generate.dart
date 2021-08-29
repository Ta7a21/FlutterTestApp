import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Generate extends StatefulWidget {
  const Generate({Key? key}) : super(key: key);

  @override
  _GenerateState createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  List<int> randomNumbers = [];
  String loading = '';

  void generateNumbers() {
    var rng = new Random();
    randomNumbers.clear();
    for (var i = 0; i < 10000; i++) {
      randomNumbers.add(rng.nextInt(10000));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  loading = 'Loading...';
                });
                generateNumbers();
                await Future.delayed(Duration(milliseconds: 100));
                setState(() {
                  loading = '';
                });
              },
              child: Text('Generate Numbers'),
              style: ElevatedButton.styleFrom(primary: Colors.black),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              loading,
              style: TextStyle(),
            )
          ],
        ),
      ),
    );
  }
}
