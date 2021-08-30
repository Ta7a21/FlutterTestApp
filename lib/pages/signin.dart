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
            padding: EdgeInsets.fromLTRB(100, 140, 100, 0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Username'),
                  onChanged: (value) => user.username = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  onChanged: (value) => user.password = value,
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          'Sign-up',
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    incorrectAuth = '';
                    bool granted = await DatabaseHelper.grantAuthorization(
                        user.username, user.password);
                    if (granted) {
                      Navigator.pushReplacementNamed(context, '/home',
                          arguments: {'username': user.username});
                    } else {
                      setState(() {
                        incorrectAuth = 'Incorrect Username or Password';
                      });
                    }
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                ),
                SizedBox(
                  height: 10,
                ),
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
