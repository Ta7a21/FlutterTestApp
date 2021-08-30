import 'package:filtration_task/services/database_helper.dart';
import 'package:filtration_task/user.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  User user = User();
  final dbHelper = DatabaseHelper.instance;
  String incorrectAuth = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign-in'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      resizeToAvoidBottomInset: false,
      body: Form(
        child: Padding(
            padding: EdgeInsets.fromLTRB(96, 136, 96, 0),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Username'),
                  onChanged: (value) => user.setUsername(value),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  onChanged: (value) => user.setPassword(value),
                  obscureText: true,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(fontSize: 14),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          'Sign-up',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ))
                  ],
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    incorrectAuth = '';
                    bool granted = await DatabaseHelper.grantAuthorization(
                        user.getUsername(), user.getPassword());
                    if (granted) {
                      Navigator.pushReplacementNamed(context, '/home',
                          arguments: {'username': user.getUsername()});
                    } else {
                      setState(() {
                        incorrectAuth = 'Incorrect Username or Password';
                      });
                    }
                  },
                  child: Text('Sign in'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                ),
                SizedBox(height: 8),
                Text(
                  incorrectAuth,
                  style: TextStyle(color: Colors.red[900]),
                ),
              ],
            )),
      ),
    );
  }
}
