import 'package:filtration_task/services/writeFile.dart';
import 'package:filtration_task/services/numbers.dart';
import 'package:flutter/material.dart';

class Generate extends StatefulWidget {
  @override
  _GenerateState createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  final _formKey = GlobalKey<FormState>();
  List<int> randomNumbers = [];
  String loadingGenNumbers = '';
  String loadingExtractedNumbers = '';
  String loadingSearch = '';
  late int _number;
  Map user = {};
  @override
  Widget build(BuildContext context) {
    user =
        user.isEmpty ? ModalRoute.of(context)!.settings.arguments as Map : user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user['username']}'),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.tryParse(value) == null)
                              return "You must enter a number";
                            return null;
                          },
                          decoration:
                              InputDecoration(labelText: 'Search for a number'),
                          onChanged: (value) {
                            try {
                              _number = int.parse(value);
                            } catch (e) {}
                          }),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loadingSearch = 'Searching...');
                            int index = Numbers.search(randomNumbers, _number);
                            await Future.delayed(Duration(milliseconds: 100));
                            setState(() => loadingSearch =
                                (index == -1) ? 'Not found..' : 'Found!!');
                          } else
                            return;
                        },
                        child: Text('Search'),
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                      ),
                    ],
                  ),
                ),
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
