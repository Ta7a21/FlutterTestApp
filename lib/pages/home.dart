import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:filtration_task/services/writeFile.dart';

class Generate extends StatefulWidget {
  const Generate({Key? key}) : super(key: key);

  @override
  _GenerateState createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  List<int> randomNumbers = [];
  String loadingGenNumbers = '';
  String loadingExtNumbers = '';
  String loadingSearch = '';
  final myController = TextEditingController();

  void generateNumbers() {
    var rng = new Random();
    randomNumbers.clear();
    for (var i = 0; i < 10000; i++) {
      randomNumbers.add(rng.nextInt(10000));
    }
  }

  int search(String number) {
    int numberToSearch = -2;
    if (int.tryParse(number) == null)
      return numberToSearch;
    else {
      numberToSearch = int.parse(number);
      randomNumbers.sort();
      // ignore: await_only_futures
      return binarySearch(randomNumbers, numberToSearch);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        centerTitle: true,
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  'Log out',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loadingGenNumbers = 'Loading...';
                  });
                  generateNumbers();
                  await Future.delayed(Duration(milliseconds: 100));
                  setState(() {
                    loadingGenNumbers = '';
                  });
                },
                child: Text('Generate Numbers'),
                style: ElevatedButton.styleFrom(primary: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                loadingGenNumbers,
                style: TextStyle(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loadingExtNumbers = 'Loading...';
                  });
                  await FileUtils.saveToFile(randomNumbers);
                  setState(() {
                    loadingExtNumbers = '';
                  });
                },
                child: Text('Extract Numbers to TXT'),
                style: ElevatedButton.styleFrom(primary: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                loadingExtNumbers,
                style: TextStyle(),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                  child: TextField(
                      controller: myController,
                      decoration:
                          InputDecoration(labelText: 'Search for a number'))),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loadingSearch = 'Searching...';
                  });
                  int index = search(myController.text);
                  await Future.delayed(Duration(milliseconds: 100));
                  setState(() {
                    loadingSearch = (index == -2)
                        ? 'You must enter a number'
                        : (index == -1)
                            ? 'Not found..'
                            : 'Found!!';
                  });
                },
                child: Text('Search'),
                style: ElevatedButton.styleFrom(primary: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                loadingSearch,
                style: TextStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
