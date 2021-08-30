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
            child: TextButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                label: Text(
                  'Log out',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )),
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
                style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    fixedSize: Size(192, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
              ),
              SizedBox(height: 8),
              Text(loadingGenNumbers),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  setState(() => loadingExtractedNumbers = 'Loading...');
                  await FileUtils.saveToFile(randomNumbers);
                  setState(() => loadingExtractedNumbers = '');
                },
                child: Text('Extract Numbers to TXT'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    fixedSize: Size(192, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
              ),
              SizedBox(height: 8),
              Text(loadingExtractedNumbers),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.fromLTRB(96, 0, 96, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.tryParse(value) == null)
                              return "You must enter an integer";
                            return null;
                          },
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Search numbers',
                            hintStyle: TextStyle(fontSize: 14),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 32),
                          ),
                          onChanged: (value) {
                            try {
                              _number = int.parse(value);
                            } catch (e) {}
                          }),
                      SizedBox(height: 8),
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
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                loadingSearch,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
