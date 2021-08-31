import 'package:authentication_app/pages/home.dart';
import 'package:authentication_app/pages/signin.dart';
import 'package:authentication_app/pages/signup.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => SignIn(),
      '/signup': (context) => SignUp(),
      '/home': (context) => Generate(),
    },
  ));
}
