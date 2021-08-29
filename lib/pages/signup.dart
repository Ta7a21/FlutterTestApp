import 'package:flutter/material.dart';
import 'package:filtration_task/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final dbHelper = DatabaseHelper.instance;

  String _fnameController = '';

  String _lnameController = '';

  String _usernameController = '';

  String _passwordController = '';

  bool flagUsername = false;

  final _formKey = GlobalKey<FormState>();

  // void dispose() {
  //   _fnameController.dispose();
  //   _lnameController.dispose();
  //   _usernameController.dispose();
  //   _passwordController.dispose();
  //   _confirmPasswordController.dispose();
  // }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach(print);
  }

  Future<bool> _insert(var password) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnFName: _fnameController,
      DatabaseHelper.columnLName: _lnameController,
      DatabaseHelper.columnUsername: _usernameController,
      DatabaseHelper.columnPassword: password.toString(),
    };
    try {
      final id = await dbHelper.insert(row);
      return true;
    } catch (e) {
      return false;
    }
    // print('inserted row id: $id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign-up'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.fromLTRB(100, 140, 100, 0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required';
                          }
                          return null;
                        },
                        // controller: _fnameController,
                        onChanged: (value) => _fnameController = value,
                        decoration:
                            const InputDecoration(labelText: 'First Name'),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required';
                          }
                          return null;
                        },
                        // controller: _lnameController,
                        onChanged: (value) => _lnameController = value,
                        decoration:
                            const InputDecoration(labelText: 'Last Name'),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required';
                    }
                    if (value.trim().length < 4) {
                      return 'Password must be at least 4 characters in length';
                    }
                    if (flagUsername) return 'username already taken';
                    return null;
                  },
                  // controller: _usernameController,
                  onChanged: (value) async {
                    Database db = await DatabaseHelper.instance.database;
                    _usernameController = value;
                    List<String> column = [DatabaseHelper.columnUsername];
                    List<dynamic> reqRow = [value];
                    List<Map> result = await db.query(DatabaseHelper.table,
                        columns: column,
                        where: '${DatabaseHelper.columnUsername} = ?',
                        whereArgs: reqRow);
                    flagUsername = result.isEmpty ? false : true;
                  },
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required';
                    }
                    if (value.trim().length < 8) {
                      return 'Password must be at least 8 characters in length';
                    }
                    return null;
                  },
                  // controller: _passwordController,
                  onChanged: (value) => _passwordController = value,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextFormField(
                  validator: (value) {
                    if (value != _passwordController)
                      return 'passwords don\'t match';
                    return null;
                  },
                  // controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var bytes = utf8.encode(_passwordController);
                      var hashedPassword = sha1.convert(bytes);
                      _insert(hashedPassword);
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/home", (r) => false);
                    } else {
                      return;
                    }
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
