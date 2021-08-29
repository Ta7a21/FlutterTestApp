import 'package:flutter/material.dart';
import 'package:filtration_task/services/database_helper.dart';

class SignUp extends StatelessWidget {
  final dbHelper = DatabaseHelper.instance;

  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnFName: _fnameController.text,
      DatabaseHelper.columnLName: _lnameController.text,
      DatabaseHelper.columnUsername: _usernameController.text,
      DatabaseHelper.columnPassword: _passwordController.text,
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
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
      resizeToAvoidBottomInset: false,
      body: Form(
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
                        controller: _fnameController,
                        decoration:
                            const InputDecoration(labelText: 'First Name'),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: _lnameController,
                        decoration:
                            const InputDecoration(labelText: 'Last Name'),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_confirmPasswordController.text !=
                          _passwordController.text)
                        return;
                      else {
                        _insert();
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/home", (r) => false);
                      }
                    },
                    child: Text('Submit'))
              ],
            )),
      ),
    );
  }
}
