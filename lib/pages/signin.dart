import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign-in'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
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
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
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
                        child: Text('Sign-up'))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(onPressed: null, child: Text('Submit'))
              ],
            )),
      ),
    );
  }
}