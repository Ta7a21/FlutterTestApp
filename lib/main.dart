import 'package:filtration_task/pages/signup.dart';
import 'package:filtration_task/pages/signin.dart';
import 'package:filtration_task/pages/home.dart';
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
