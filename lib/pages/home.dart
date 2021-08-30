import 'package:filtration_task/services/writeFile.dart';
import 'package:filtration_task/services/numbers.dart';
import 'package:flutter/material.dart';

class Generate extends StatefulWidget {
  @override
  _GenerateState createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  List<int> randomNumbers = [];
  String loadingGenNumbers = '';
  String loadingExtractedNumbers = '';
  String loadingSearch = '';
  final numberController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        backgroundColor: Colors.black,
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
                  setState(() => loadingGenNumbers = 'Loading...');
                  randomNumbers = Numbers.generateNumbers();
                  await Future.delayed(Duration(milliseconds: 100));
                  setState(() => loadingGenNumbers = '');
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
                  setState(() => loadingExtractedNumbers = 'Loading...');
                  await FileUtils.saveToFile(randomNumbers);
                  setState(() => loadingExtractedNumbers = '');
                },
                child: Text('Extract Numbers to TXT'),
                style: ElevatedButton.styleFrom(primary: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                loadingExtractedNumbers,
                style: TextStyle(),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                  child: TextField(
                      controller: numberController,
                      decoration:
                          InputDecoration(labelText: 'Search for a number'))),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  setState(() => loadingSearch = 'Searching...');
                  int index =
                      Numbers.search(randomNumbers, numberController.text);
                  await Future.delayed(Duration(milliseconds: 100));
                  setState(() => loadingSearch = (index == -2)
                      ? 'You must enter a number'
                      : (index == -1)
                          ? 'Not found..'
                          : 'Found!!');
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
