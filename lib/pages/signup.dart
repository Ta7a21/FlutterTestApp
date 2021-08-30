import 'package:filtration_task/services/database_helper.dart';
import 'package:filtration_task/user.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  User user = User();
  final dbHelper = DatabaseHelper.instance;

  bool isUsername = false;
  final _formKey = GlobalKey<FormState>();

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
                            return 'Required';
                          }
                          return null;
                        },
                        onChanged: (value) => user.firstname = value,
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
                            return 'Required';
                          }
                          return null;
                        },
                        onChanged: (value) => user.lastname = value,
                        decoration:
                            const InputDecoration(labelText: 'Last Name'),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (value.trim().length < 4) {
                      return 'Username must be at least 4 characters in length';
                    }
                    if (isUsername) return 'Username already taken';
                    return null;
                  },
                  onChanged: (value) async {
                    user.username = value;
                    List<Map> resultSet =
                        await DatabaseHelper.checkUsername(value);

                    isUsername = resultSet.isEmpty ? false : true;
                  },
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (value.trim().length < 8) {
                      return 'Password must be at least 8 characters in length';
                    }
                    return null;
                  },
                  onChanged: (value) => user.password = value,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextFormField(
                  validator: (value) {
                    if (value != user.password) return 'Passwords don\'t match';
                    return null;
                  },
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
                      User.addToDatabase(user);
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
