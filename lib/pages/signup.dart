import 'package:filtration_task/services/database_helper.dart';
import 'package:filtration_task/services/userDB.dart';
import 'package:filtration_task/userModel.dart';
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
                        onChanged: (value) => user.firstname = value,
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
                      return 'Enter at least 4 characters';
                    }
                    if (isUsername) return 'Username already taken';
                    return null;
                  },
                  onChanged: (value) async {
                    user.username = value;
                    List<Map> resultSet =
                        await DatabaseHelper.getUsername(value);

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
                      return 'Enter at least 8 characters';
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
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      UserDB.add(user);
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/home", (r) => false,
                          arguments: {'username': user.username});
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
