import 'package:flutter/material.dart';
import 'package:filtration_task/pages/signup.dart';
import 'package:filtration_task/pages/generate.dart';
import 'package:filtration_task/pages/signin.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/signup': (context) => SignUp(),
      '/signin': (context) => SignIn(),
      '/': (context) => Generate(),
    },
  ));
}
