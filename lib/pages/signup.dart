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
            padding: EdgeInsets.fromLTRB(96, 136, 96, 0),
            child: Column(
              children: [
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
                        onChanged: (value) => user.setFName(value),
                        decoration:
                            const InputDecoration(labelText: 'First Name'),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Flexible(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        onChanged: (value) => user.setLName(value),
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
                    user.setUsername(value);
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
                  onChanged: (value) => user.setPassword(value),
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextFormField(
                  validator: (value) {
                    if (value != user.getPassword())
                      return 'Passwords don\'t match';
                    return null;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      User.addToDatabase(user);
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/home", (r) => false,
                          arguments: {'username': user.getUsername()});
                    } else {
                      return;
                    }
                  },
                  child: Text('Sign up'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
